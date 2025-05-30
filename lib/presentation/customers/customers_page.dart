import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/presentation/bloc/customers/customers_bloc.dart';
import 'package:route_to_market/presentation/customers/widgets/customer_widget.dart';
import 'package:route_to_market/presentation/visits/customer_visit.dart';

import '../components/custom_box.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersBloc, CustomersState>(
      builder: (context, state) {
        if (state.status == CustomersStatus.loading &&
            state.customers.isEmpty) {
          return const CenteredColumn(
            content: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state.status == CustomersStatus.error && state.customers.isEmpty) {
          return CenteredColumn(content: Text(state.message));
        }

        List<Customer> customers =
            state.customers.map((e) => Customer.fromJson(e)).toList();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView.separated(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              Customer customer = customers[index];
              return BuildCustomerInfo(
                customer: customer,
                onClick: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => CustomerVisitPage(customer: customer),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => SizedBox(height: 32),
          ),
        );
      },
    );
  }
}
