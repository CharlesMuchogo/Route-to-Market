

import 'package:hive_flutter/adapters.dart';
import 'package:route_to_market/domain/dto/Visit_dto.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';

import 'LocalDatabase.dart';

class LocalDatabaseImpl implements LocalDatabase {

   final String VISIT_BOX =  "visits";
   final String ACTIVITIES_BOX =  "activities";

  @override
  Future<void> initializeHiveDatabase() async {
    await Hive.initFlutter();
    await Hive.openBox(VISIT_BOX);
    await Hive.openBox(ACTIVITIES_BOX);
  }

  @override
  Future<void> deleteAllSavedVisits() async {
    Box offlineVisits = Hive.box(VISIT_BOX);
    await offlineVisits.clear();
  }

  @override
  Future<List<VisitDto>> getSavedVisits() async {
    Box offlineVisits = Hive.box(VISIT_BOX);
    return offlineVisits.values
         .map((e) => VisitDto.fromJson(Map<String, dynamic>.from(e)))
         .toList();
  }

  @override
  Future<void> saveVisit(VisitDto visit) async {
    Box offlineVisits = Hive.box(VISIT_BOX);
    await offlineVisits.add(visit.toJson());
  }

  @override
  Future<void> deleteSavedVisit(VisitDto visit) async {
    final box = Hive.box(VISIT_BOX);

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

  @override
  Future<Activity> getActivity(int id) async {
    Box activitiesBox = Hive.box(ACTIVITIES_BOX);
    Map<String, dynamic>? activity =  activitiesBox.getAt(id);

    if (activity == null) {
      throw Exception('Activity not found');
    }
    return Activity.fromJson(activity);
  }

  @override
  Future<void> saveActivity(Activity activity) async {
    Box activitiesBox = Hive.box(ACTIVITIES_BOX);
    await activitiesBox.add(activity);
  }

  @override
  Future<void> deleteAllActivities() async {
    Box activitiesBox = Hive.box(ACTIVITIES_BOX);
    await activitiesBox.clear();
  }

  @override
  Future<void> saveActivities(List<Activity> activities) async{
    for (Activity activity in activities){
      Box activitiesBox = Hive.box(ACTIVITIES_BOX);
      await activitiesBox.add(activity);
    }
  }

}