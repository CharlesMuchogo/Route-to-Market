import 'package:route_to_market/data/remote/mock_data.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/dto/visit_response_dto.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';

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
