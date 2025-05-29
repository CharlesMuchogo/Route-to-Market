
import 'dart:ffi';

import 'package:route_to_market/domain/dto/Visit_dto.dart';

abstract class LocalDatabase {
  Future<void>  initializeHiveDatabase();

  Future<void> saveVisit(VisitDto visit);

  Future<List<VisitDto>> getSavedVisits();

  Future<void> deleteAllSavedVisits();

  Future<void> deleteSavedVisit(VisitDto visit);

}