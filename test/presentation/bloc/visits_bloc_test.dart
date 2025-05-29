import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_to_market/data/local/LocalDatabase.dart';
import 'package:route_to_market/data/remote/MockData.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/data/remote/RemoteRepositoryMock.dart';
import 'package:route_to_market/presentation/bloc/visits/visits_bloc.dart';

class MockStorage extends Mock implements Storage {}
class MockLocalDatabase extends Mock implements LocalDatabase {}
class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group("Test visits bloc is set up correctly", () {
    late VisitsBloc visitsBloc;
    late RemoteRepository mockRepository;
    late LocalDatabase mockLocalDatabase;
    late Connectivity mockConnectivity;
    late Storage storage;

    setUp(() async {
      storage = MockStorage();
      when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
      when(() => storage.read(any())).thenAnswer((_) async => null);
      HydratedBloc.storage = storage;

      mockRepository = RemoteRepositoryMock();
      mockLocalDatabase = MockLocalDatabase();
      mockConnectivity = MockConnectivity();

      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi] );

      when(() => mockLocalDatabase.initializeHiveDatabase())
          .thenAnswer((_) async {});

      EquatableConfig.stringify = true;

      visitsBloc = VisitsBloc(
        repository: mockRepository,
        database: mockLocalDatabase,
        connectivity: mockConnectivity,
      );
    });

    tearDown(() {
      visitsBloc.close();
    });

    blocTest<VisitsBloc, VisitsState>(
      "Test if visits are rendered correctly",
      build: () => visitsBloc,
      act: (bloc) async {
        bloc.add(GetVisits());
        await Future.delayed(Duration(seconds: 5));
      },
      expect: () => [
        VisitsState(status: VisitsStatus.loading),
        VisitsState(
          status: VisitsStatus.loaded,
          visits: fakeVisits.map((e) => e.toJson()).toList(),
          message: "Visits fetched Successfully",
        )
      ],
    );
  });
}