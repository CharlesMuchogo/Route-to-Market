
import 'package:json_annotation/json_annotation.dart';

part 'Visit_response_dto.g.dart';

@JsonSerializable()
class VisitResponseDto {

  VisitResponseDto();

  factory VisitResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VisitResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VisitResponseDtoToJson(this);
}
