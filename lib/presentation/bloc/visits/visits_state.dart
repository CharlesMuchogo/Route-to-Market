part of 'visits_bloc.dart';

class VisitsState extends Equatable {
  final List visits;
  final List<Visit> customerVisits;
  final List<VisitDto> offlineVisits;
  final VisitsStatus status;
  final String message;
  final int? currentCustomerId;
  final VisitFilters visitFilters;

  const VisitsState({
    this.visits = const [],
    this.customerVisits = const [],
    this.offlineVisits = const [],
    this.message = "",
    this.currentCustomerId,
    this.status = VisitsStatus.initial,
    this.visitFilters = const VisitFilters(),
  });

  VisitsState copyWith({
    List? visits,
    List<Visit>? customerVisits,
    List<VisitDto>? offlineVisits,
    int? currentCustomerId,
    String? message,
    VisitsStatus? status,
    VisitFilters? visitFilters,
  }) {
    return VisitsState(
      visits: visits ?? this.visits,
      status: status ?? this.status,
      offlineVisits: offlineVisits ?? this.offlineVisits,
      customerVisits: customerVisits ?? this.customerVisits,
      message: message ?? this.message,
      visitFilters: visitFilters ?? this.visitFilters,
      currentCustomerId: currentCustomerId ?? this.currentCustomerId,
    );
  }

  @override
  List<Object> get props => [visits, status, message];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'visits': visits,
      'message': message,
      'status': status.index,
    };
  }

  factory VisitsState.fromMap(Map<String, dynamic> map) {
    int index = map['status'];

    return VisitsState(
      visits: List.from((map['visits'] as List)),
      message: map['message'],
      status: VisitsStatus.values[index],
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitsState.fromJson(String source) =>
      VisitsState.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum VisitsStatus {
  initial,
  loading,
  submitting,
  loaded,
  error,
  failed,
  success,
}
