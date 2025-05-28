part of 'activities_bloc.dart';


class ActivitiesState extends Equatable {
  final List activities;
  final ActivitiesStatus status;
  final String message;

  const ActivitiesState({
    this.activities = const [],
    this.message = "",
    this.status = ActivitiesStatus.initial,
  });

  ActivitiesState copyWith({
    List? activities,
    String? message,
    ActivitiesStatus? status,
    bool? loggedIn,
  }) {
    return ActivitiesState(
      activities: activities ?? this.activities,
      status: status ?? this.status,
      message: message ?? this.message
    );
  }

  @override
  List<Object> get props => [activities, status, message];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'activities': activities, 'message': message , 'status': status.index};
  }

  factory ActivitiesState.fromMap(Map<String, dynamic> map) {
    int index = map['status'];

    return ActivitiesState(
      activities: List.from((map['activities'] as List)),
      message: map['message'] ,
      status: ActivitiesStatus.values[index],
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivitiesState.fromJson(String source) =>
      ActivitiesState.fromMap(json.decode(source) as Map<String, dynamic>);
}

enum ActivitiesStatus { initial, loading, loaded, error, failed, success }
