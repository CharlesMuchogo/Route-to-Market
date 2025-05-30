import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:route_to_market/data/local/local_database.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';
import 'package:route_to_market/domain/models/visit/visit_filters.dart';

part 'visits_event.dart';
part 'visits_state.dart';

class VisitsBloc extends HydratedBloc<VisitsEvent, VisitsState> {
  final RemoteRepository repository;
  final LocalDatabase database;
  final Connectivity connectivity;

  late StreamSubscription connectivitySubscription;

  VisitsBloc({
    required this.repository,
    required this.database,
    required this.connectivity,
  }) : super(const VisitsState()) {
    on<GetVisits>(_onGetVisits);
    on<GetCustomerVisits>(_onGetCustomerVisits);
    on<FilterCustomerVisits>(_onFilterCustomerVisits);
    on<MakeVisit>(_onMakeVisit);
    on<MonitorConnectivity>(_monitorConnectivity);
    on<SyncVisits>(_onSyncVisits);
  }

  void _onGetVisits(GetVisits event, Emitter<VisitsState> emit) async {
    if (state.status == VisitsStatus.initial) {
      emit(state.copyWith(status: VisitsStatus.loading));
    }

    try {
      List<Visit> results = await repository.fetchVisits();
      List<VisitDto> offlineVisits = await database.getSavedVisits();

      emit(
        state.copyWith(
          status: VisitsStatus.loaded,
          message: "Visits fetched Successfully",
          offlineVisits: offlineVisits,
          visits: results.map((e) => e.toJson()).toList(),
        ),
      );

      if (state.currentCustomerId != null) {
        add(
          FilterCustomerVisits(
            filters: state.visitFilters,
            id: state.currentCustomerId!,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: VisitsStatus.error, message: e.toString()));
    }
  }

  void _onGetCustomerVisits(
    GetCustomerVisits event,
    Emitter<VisitsState> emit,
  ) async {
    emit(state.copyWith(status: VisitsStatus.loading));

    List<Visit> visits =
        state.visits.map((visit) => Visit.fromJson(visit)).toList();

    List<Visit> customerVisits =
        visits.where((visit) => visit.customerId == event.id).toList();

    customerVisits.sort((a, b) => b.visitDate.compareTo(a.visitDate));

    emit(
      state.copyWith(
        status: VisitsStatus.loaded,
        currentCustomerId: event.id,
        customerVisits: customerVisits,
      ),
    );
  }

  void _onFilterCustomerVisits(
    FilterCustomerVisits event,
    Emitter<VisitsState> emit,
  ) async {
    emit(state.copyWith(status: VisitsStatus.loading));

    List<Visit> visits =
        state.visits.map((visit) => Visit.fromJson(visit)).toList();

    List<Visit> customerVisits =
        visits.where((visit) => visit.customerId == event.id).toList();

    if (event.filters.ascending) {
      customerVisits.sort((a, b) => a.visitDate.compareTo(b.visitDate));
    } else {
      customerVisits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    }

    if (event.filters.status != null) {
      customerVisits =
          state.customerVisits
              .where(
                (visit) =>
                    visit.status.toLowerCase() ==
                    event.filters.status!.toLowerCase(),
              )
              .toList();
    }

    String searchParam = event.filters.searchParam.toLowerCase();
    if (searchParam.isNotEmpty) {
      customerVisits =
          state.customerVisits
              .where(
                (visit) =>
                    visit.location.toLowerCase().contains(searchParam) ||
                    visit.notes.toLowerCase().contains(searchParam),
              )
              .toList();
    }

    emit(
      state.copyWith(
        status: VisitsStatus.loaded,
        currentCustomerId: event.id,
        visitFilters: event.filters,
        customerVisits: customerVisits,
      ),
    );
  }

  void _onMakeVisit(MakeVisit event, Emitter<VisitsState> emit) async {
    emit(state.copyWith(status: VisitsStatus.submitting));
    try {
      // Save visit locally first
      await database.saveVisit(event.visitDto);

      // Attempt to Sync visits
      add(SyncVisits());

      List<VisitDto> offlineVisits = await database.getSavedVisits();

      emit(
        state.copyWith(
          status: VisitsStatus.success,
          offlineVisits: offlineVisits,
          message: "Visit made Successfully",
        ),
      );
    } catch (e) {
      log("Error Syncing visits 1  ${e.toString()}");
      emit(state.copyWith(status: VisitsStatus.error, message: e.toString()));
    }
  }

  void _onSyncVisits(SyncVisits event, Emitter<VisitsState> emit) async {
    try {
      // sync the visits
      List<VisitDto> localVisits = await database.getSavedVisits();

      await repository.makeVisits(localVisits);
      await database.deleteAllSavedVisits();
      // Fetch synced visits from the server
      add(GetVisits());
    } catch (e) {
      log("Error Syncing visits  ${e.toString()}");
    }
  }

  void _monitorConnectivity(
    MonitorConnectivity event,
    Emitter<VisitsState> emit,
  ) {
    connectivitySubscription = connectivity.onConnectivityChanged.listen((
      connectivityResult,
    ) async {
      if (connectivityResult.contains(ConnectivityResult.none)) {
        log("Internet Disconnected");
      } else {
        final isOnline = await _checkInternetAccess();
        if (isOnline) {
          log("Internet Connected: $connectivityResult");
          add(SyncVisits());
        }
      }
    });
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }

  @override
  VisitsState fromJson(Map<String, dynamic> data) {
    return VisitsState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(VisitsState state) {
    if (state.status == VisitsStatus.loaded ||
        state.status == VisitsStatus.success) {
      return state.toMap();
    }
    return null;
  }
}
