part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}

class InternetLoading extends InternetState {}

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected({required this.connectionType});
}

class InternetConnecting extends InternetState {}

class InternetDisconnected extends InternetState {}

class InternetReconnected extends InternetState {}
