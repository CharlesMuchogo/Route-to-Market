import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/dto/visit_response_dto.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';

abstract class RemoteRepository {
  Future<List<Customer>> fetchCustomers();

  Future<List<Activity>> fetchActivities();

  Future<List<Visit>> fetchVisits();

  Future<VisitResponseDto> makeVisit(VisitDto visitDto);

  Future<VisitResponseDto> makeVisits(List<VisitDto> visitDto);
}
