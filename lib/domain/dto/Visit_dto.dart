
import 'package:json_annotation/json_annotation.dart';

part 'Visit_dto.g.dart';

@JsonSerializable()
class VisitDto {

  @JsonKey(name: 'customer_id')
  final int customerId;
  @JsonKey(name: 'visit_date')
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  @JsonKey(name: 'activities_done')
  final List<String> activitiesDone;
  final bool synced;

  VisitDto({
    this.synced = false,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
  });

  factory VisitDto.fromJson(Map<String, dynamic> json) =>
      _$VisitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VisitDtoToJson(this);
}
