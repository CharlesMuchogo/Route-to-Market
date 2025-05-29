

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_to_market/data/remote/MockData.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/data/remote/RemoteRepositoryMock.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';

class MockStorage extends Mock implements Storage {}

void main(){
  group(
    "Test activities bloc",
        () {
      late ActivitiesBloc activitiesBloc;
      RemoteRepository mockRepository;
      late Storage storage;

      setUp(() async {
        storage = MockStorage();
        when(() => storage.write(any(), any<dynamic>()))
            .thenAnswer((_) async {});
        when(() => storage.read(any()))
            .thenAnswer((_) async => null);
        HydratedBloc.storage = storage;

        EquatableConfig.stringify = true;
        mockRepository = RemoteRepositoryMock();
        activitiesBloc = ActivitiesBloc(repository: mockRepository);
      });

      blocTest<ActivitiesBloc, ActivitiesState>(
        "Test if activities are rendered correctly",
        build: () => activitiesBloc,
        act: (bloc) async {
          bloc.add(GetActivities());
          await Future.delayed(Duration(seconds: 5));
        },
        expect: () => [
          ActivitiesState(status: ActivitiesStatus.loading),
          ActivitiesState(
            status: ActivitiesStatus.loaded,
            activities: fakeActivities.map((e) => e.toJson()).toList(),
            message: "Activities fetched Successfully",
          )
        ],
      );
    },
  );
}