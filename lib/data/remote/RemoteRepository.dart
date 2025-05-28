
import 'package:route_to_market/domain/dto/Visit_dto.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/domain/models/visit/Visit.dart';

abstract class RemoteRepository {

  Future<List<Customer>> fetchCustomers();

  Future<List<Activity>> fetchActivities();

  Future<List<Visit>> fetchVisits();

  Future<List<Visit>> makeVisits(VisitDto visitDto);

}