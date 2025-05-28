// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'customers_bloc.dart';

abstract class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object> get props => [];
}

class GetCustomers extends CustomersEvent {
  const GetCustomers();
}
