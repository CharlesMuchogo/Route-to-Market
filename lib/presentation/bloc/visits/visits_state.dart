part of 'visits_bloc.dart';

class VisitsState extends Equatable {
  final List visits;
  final VisitsStatus status;
  final String message;

  const VisitsState({
    this.visits = const [],
    this.message = "",
    this.status = VisitsStatus.initial,
  });

  VisitsState copyWith({
    List? visits,
    String? message,
    VisitsStatus? status,
    bool? loggedIn,
  }) {
    return VisitsState(
      visits: visits ?? this.visits,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  List<Object> get props => [visits, status, message];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'visits': visits, 'message': message , 'status': status.index};
  }

  factory VisitsState.fromMap(Map<String, dynamic> map) {
    int index = map['status'];

    return VisitsState(
      visits: List.from((map['visits'] as List)),
      message: map['message'] ,
      status: VisitsStatus.values[index],
    );
  }

  String toJson() => json.encode(toMap());

  factory VisitsState.fromJson(String source) =>
      VisitsState.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum VisitsStatus { initial, loading, loaded, error, failed, success }
