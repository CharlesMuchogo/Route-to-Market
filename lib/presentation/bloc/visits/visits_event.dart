// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'visits_bloc.dart';

abstract class VisitsEvent extends Equatable {
  const VisitsEvent();

  @override
  List<Object> get props => [];
}

class MonitorConnectivity extends VisitsEvent {
  const MonitorConnectivity();
}

class SyncVisits extends VisitsEvent {
  const SyncVisits();
}

class GetVisits extends VisitsEvent {
  const GetVisits();
}

class MakeVisit extends VisitsEvent {
  final VisitDto visitDto;
  const MakeVisit({required this.visitDto});
}
