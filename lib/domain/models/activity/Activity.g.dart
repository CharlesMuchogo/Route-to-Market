// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
  id: (json['id'] as num).toInt(),
  description: json['description'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
  'id': instance.id,
  'description': instance.description,
  'created_at': instance.createdAt.toIso8601String(),
};
