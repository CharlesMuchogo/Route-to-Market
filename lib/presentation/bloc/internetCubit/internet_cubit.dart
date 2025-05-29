import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/data/local/LocalDatabase.dart';
import 'package:route_to_market/data/remote/RemoteRepository.dart';
import 'package:route_to_market/utils/Utils.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;
  final LocalDatabase localDatabase;
  final RemoteRepository remoteRepository;

  InternetCubit({
    required this.connectivity,
    required this.localDatabase,
    required this.remoteRepository,
  }) : super(InternetLoading()) {
    monitorInternetConnection();
  }

  StreamSubscription<List<ConnectivityResult>> monitorInternetConnection() {
    return connectivityStreamSubscription = connectivity.onConnectivityChanged
        .listen((connectivityResult) {
          if (connectivityResult.contains( ConnectivityResult.wifi)) {
            if (state is InternetDisconnected) {
              emitInternetReconnected();
            }
            emitInternetConnected(ConnectionType.Wifi);
          } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
            if (state is InternetDisconnected) {
              emitInternetReconnected();
            }
            emitInternetConnected(ConnectionType.Mobile);
          } else if (connectivityResult.contains(ConnectivityResult.none)) {
            emitInternetDisconnected();
          }
        });
  }

  Future<bool> checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  void emitInternetConnected(ConnectionType _connectionType) =>
      emit(InternetConnected(connectionType: _connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  void emitInternetReconnected() => emit(InternetReconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
