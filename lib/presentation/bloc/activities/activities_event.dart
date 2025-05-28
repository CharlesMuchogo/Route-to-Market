// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'activities_bloc.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class GetActivities extends ActivitiesEvent {
  const GetActivities();
}
