import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:route_to_market/data/remote/remote_repository.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends HydratedBloc<CustomersEvent, CustomersState> {
  final RemoteRepository repository;

  CustomersBloc({required this.repository}) : super(const CustomersState()) {
    on<GetCustomers>(_onGetCustomers);
  }

  void _onGetCustomers(GetCustomers event, Emitter<CustomersState> emit) async {
    if (state.status == CustomersStatus.initial) {
      emit(state.copyWith(status: CustomersStatus.loading));
    }
    try {
      List<Customer> results = await repository.fetchCustomers();

      emit(
        state.copyWith(
          status: CustomersStatus.loaded,
          message: "Customers fetched Successfully",
          customers: results.map((e) => e.toJson()).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: CustomersStatus.error, message: e.toString()),
      );
    }
  }

  @override
  CustomersState fromJson(Map<String, dynamic> data) {
    return CustomersState.fromJson(json.encode(data));
  }

  @override
  Map<String, dynamic>? toJson(CustomersState state) {
    if (state.status == CustomersStatus.loaded ||
        state.status == CustomersStatus.success) {
      return state.toMap();
    }
    return null;
  }

  @override
  void onChange(Change<CustomersState> change) {
    super.onChange(change);
    debugPrint('$change');
  }
}
