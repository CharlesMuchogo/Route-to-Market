import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';

abstract class LocalDatabase {
  Future<void> initializeHiveDatabase();

  Future<void> saveVisit(VisitDto visit);

  Future<List<VisitDto>> getSavedVisits();

  Future<void> deleteAllSavedVisits();

  Future<void> deleteSavedVisit(VisitDto visit);

  Future<void> saveActivity(Activity activity);

  Future<void> saveActivities(List<Activity> activities);

  Future<Activity> getActivity(int id);

  Future<void> deleteAllActivities();
}
