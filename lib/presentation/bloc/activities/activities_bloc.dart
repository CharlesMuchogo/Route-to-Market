import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:route_to_market/data/local/local_database.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends HydratedBloc<ActivitiesEvent, ActivitiesState> {
  final RemoteRepository repository;
  final LocalDatabase localDatabase;

  ActivitiesBloc({required this.repository, required this.localDatabase})
    : super(const ActivitiesState()) {
    on<GetActivities>(_onGetActivities);
    on<GetVisitActivities>(_onGetVisitActivities);
  }

  void _onGetActivities(
    GetActivities event,
    Emitter<ActivitiesState> emit,
  ) async {
    if (state.status == ActivitiesStatus.initial) {
      emit(state.copyWith(status: ActivitiesStatus.loading));
    }

    try {
      List<Activity> results = await repository.fetchActivities();

      emit(
        state.copyWith(
          status: ActivitiesStatus.loaded,
          message: "Activities fetched Successfully",
          activities: results.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: ActivitiesStatus.error, message: e.toString()),
      );
    }
  }

  void _onGetVisitActivities(
    GetVisitActivities event,
    Emitter<ActivitiesState> emit,
  ) {
    emit(state.copyWith(status: ActivitiesStatus.loading));

    List<Activity> activities =
        state.activities.map((e) => Activity.fromJson(e)).toList();

    List<Activity> visitActivities =
        activities
            .where((activity) => event.activities.contains(activity.id))
            .toList();

    emit(
      state.copyWith(
        visitActivities: visitActivities,
        status: ActivitiesStatus.loaded,
      ),
    );
  }

  @override
  ActivitiesState fromJson(Map<String, dynamic> data) {
    return ActivitiesState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(ActivitiesState state) {
    if (state.status == ActivitiesStatus.loaded ||
        state.status == ActivitiesStatus.success) {
      return state.toMap();
    }
    return null;
  }

  @override
  void onChange(Change<ActivitiesState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
