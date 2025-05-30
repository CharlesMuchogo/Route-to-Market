// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitDto _$VisitDtoFromJson(Map<String, dynamic> json) => VisitDto(
  customerId: (json['customer_id'] as num).toInt(),
  visitDate: DateTime.parse(json['visit_date'] as String),
  status: json['status'] as String,
  location: json['location'] as String,
  notes: json['notes'] as String,
  activitiesDone:
      (json['activities_done'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$VisitDtoToJson(VisitDto instance) => <String, dynamic>{
  'customer_id': instance.customerId,
  'visit_date': instance.visitDate.toIso8601String(),
  'status': instance.status,
  'location': instance.location,
  'notes': instance.notes,
  'activities_done': instance.activitiesDone,
};
