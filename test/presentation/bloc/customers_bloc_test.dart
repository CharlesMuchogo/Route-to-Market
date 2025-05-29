

import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:route_to_market/data/remote/MockData.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/data/remote/RemoteRepositoryMock.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/bloc/customers/customers_bloc.dart';
import 'package:route_to_market/presentation/bloc/customers/customers_bloc.dart';
import 'package:route_to_market/presentation/bloc/customers/customers_bloc.dart';

class MockStorage extends Mock implements Storage {}

void main(){
  group(
    "Test Customers bloc is set up correctly",
        () {
      late CustomersBloc activitiesBloc;
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
        activitiesBloc = CustomersBloc(repository: mockRepository);
      });


      blocTest<CustomersBloc, CustomersState>(
        "Test if activities are rendered correctly",
        build: () => activitiesBloc,
        act: (bloc) async {
          bloc.add(GetCustomers());
          await Future.delayed(Duration(seconds: 5));
        },
        expect: () => [
          CustomersState(status: CustomersStatus.loading),
          CustomersState(
            status: CustomersStatus.loaded,
            customers: fakeCustomers.map((e) => e.toJson()).toList(),
            message: "Customers fetched Successfully",
          )
        ],
      );
    },
  );
}