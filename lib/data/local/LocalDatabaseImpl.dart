

import 'package:hive_flutter/adapters.dart';
import 'package:route_to_market/domain/dto/Visit_dto.dart';

import 'LocalDatabase.dart';

class LocalDatabaseImpl implements LocalDatabase {



  @override
  Future<void> initializeHiveDatabase() async {
    await Hive.initFlutter();
    await Hive.openBox("visits");
  }

  @override
  Future<void> deleteAllSavedVisits() async {
    Box offlineVisits = Hive.box("visits");
    await offlineVisits.clear();
  }

  @override
  Future<List<VisitDto>> getSavedVisits() async {
    Box offlineVisits = Hive.box("visits");
    return offlineVisits.values
         .map((e) => VisitDto.fromJson(Map<String, dynamic>.from(e)))
         .toList();
  }

  @override
  Future<void> saveVisit(VisitDto visit) async {
    Box offlineVisits = Hive.box("visits");
    offlineVisits.add(visit.toJson());
  }

  @override
  Future<void> deleteSavedVisit(VisitDto visit) async {
    final box = Hive.box("visits");

    final keyToDelete = box.keys.firstWhere(
          (key) {
        final storedVisit = box.get(key);
        if (storedVisit is Map<String, dynamic>) {
          return storedVisit['visit_date'] == visit.visitDate;
        } else if (storedVisit is Map) {
          return storedVisit['visit_date'] == visit.visitDate;
        }
        return false;
      },
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
    }
  }
}