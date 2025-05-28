import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:route_to_market/data/local/LocalDatabase.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/bloc/customers/customers_bloc.dart';
import 'package:route_to_market/presentation/bloc/visits/visits_bloc.dart';
import 'package:route_to_market/presentation/customers/Customers_Page.dart';

import 'data/local/LocalDatabaseImpl.dart';
import 'data/remote/RemoteRepository.dart';
import 'data/remote/RemoteRepositoryImpl.dart';

void main() async {
  LocalDatabase localDatabase = LocalDatabaseImpl();
  await localDatabase.initializeHiveDatabase();

  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getApplicationDocumentsDirectory(),
  );



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    RemoteRepository repository = RemoteRepositoryImpl();
    LocalDatabase localDatabase = LocalDatabaseImpl();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  CustomersBloc(repository: repository)..add(GetCustomers()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ActivitiesBloc(repository: repository)..add(GetActivities()),
        ),
        BlocProvider(
          create:
              (context) =>
                  VisitsBloc(repository: repository, database: localDatabase)
                    ..add(GetVisits()),
        ),
      ],
      child: MaterialApp(
        title: 'Route To Market',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.black),
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const CustomersPage(),
      ),
    );
  }
}
