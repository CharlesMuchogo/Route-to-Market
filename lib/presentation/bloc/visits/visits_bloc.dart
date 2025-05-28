import 'dart:convert';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:route_to_market/data/local/LocalDatabase.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/domain/dto/Visit_dto.dart';
import 'package:route_to_market/domain/dto/Visit_response_dto.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/domain/models/visit/Visit.dart';

part 'visits_event.dart';part 'visits_state.dart';

class VisitsBloc extends HydratedBloc<VisitsEvent, VisitsState> {
  final RemoteRepository repository;
  final LocalDatabase database;

  VisitsBloc({required this.repository, required this.database}) : super(const VisitsState()) {
    on<GetVisits>(_onGetCustomers);
    on<MakeVisit>(_onMakeVisit);
  }

  void _onGetCustomers(GetVisits event, Emitter<VisitsState> emit) async {
    if (state.status == VisitsStatus.initial) {
      emit(state.copyWith(status: VisitsStatus.loading));
    }

    try {
      List<Visit> results = await repository.fetchVisits();

      emit(
        state.copyWith(
          status: VisitsStatus.loaded,
          message: "Visits fetched Successfully",
          visits: results.map((e) => e.toJson()).toList()
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: VisitsStatus.error, message: e.toString()),
      );
    }
  }

  void _onMakeVisit(MakeVisit event, Emitter<VisitsState> emit) async {
      emit(state.copyWith(status: VisitsStatus.submitting));
    try {

      database.saveVisit(event.visitDto);

      List<VisitDto> visits = await database.getSavedVisits();

      log("Saved visits are ${visits.length}");

      //VisitResponseDto results = await repository.makeVisits(event.visitDto);

      emit(
        state.copyWith(
          status: VisitsStatus.success,
          message: "Visit made Successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: VisitsStatus.error, message: e.toString()),
      );
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

  @override
  void onChange(Change<VisitsState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
