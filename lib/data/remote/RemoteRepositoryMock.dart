import 'package:route_to_market/data/remote/MockData.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/domain/dto/Visit_dto.dart';
import 'package:route_to_market/domain/dto/Visit_response_dto.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/domain/models/visit/Visit.dart';

class RemoteRepositoryMock implements RemoteRepository {
  @override
  Future<List<Activity>> fetchActivities() {
    return Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => fakeActivities);
  }

  @override
  Future<List<Customer>> fetchCustomers() {
    return Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => fakeCustomers);
  }

  @override
  Future<List<Visit>> fetchVisits() {
    return Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => fakeVisits);
  }

  @override
  Future<VisitResponseDto> makeVisit(VisitDto visitDto) {
    return Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => VisitResponseDto());
  }

  @override
  Future<VisitResponseDto> makeVisits(List<VisitDto> visitDto) {
    return Future.delayed(
      const Duration(seconds: 3),
    ).then((value) => VisitResponseDto());
  }
}
