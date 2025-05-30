import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_to_market/data/local/local_database.dart';
import 'package:route_to_market/data/remote/mock_data.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/data/remote/remote_repository_mock.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';

class MockStorage extends Mock implements Storage {}

class MockLocalDatabase extends Mock implements LocalDatabase {}

void main() {
  group("Test activities bloc", () {
    late ActivitiesBloc activitiesBloc;
    RemoteRepository mockRepository;
    LocalDatabase mockLocalDatabase;
    late Storage storage;

    setUp(() async {
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.read(any())).thenAnswer((_) async => null);
      HydratedBloc.storage = storage;

      EquatableConfig.stringify = true;
      mockRepository = RemoteRepositoryMock();
      mockLocalDatabase = MockLocalDatabase();

      when(
        () => mockLocalDatabase.deleteAllActivities(),
      ).thenAnswer((_) async {});
      when(
        () => mockLocalDatabase.saveActivities(any()),
      ).thenAnswer((_) async {});

      activitiesBloc = ActivitiesBloc(
        repository: mockRepository,
        localDatabase: mockLocalDatabase,
      );
    });

    blocTest<ActivitiesBloc, ActivitiesState>(
      "Test if activities are rendered correctly",
      build: () => activitiesBloc,
      act: (bloc) async {
        bloc.add(GetActivities());
        await Future.delayed(Duration(seconds: 5));
      },
      expect:
          () => [
            ActivitiesState(status: ActivitiesStatus.loading),
            ActivitiesState(
              status: ActivitiesStatus.loaded,
              activities: fakeActivities.map((e) => e.toJson()).toList(),
              message: "Activities fetched Successfully",
            ),
          ],
    );
  });
}
