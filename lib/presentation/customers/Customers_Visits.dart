import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/domain/models/visit/Visit.dart';
import 'package:route_to_market/domain/models/visit/VisitFilters.dart';
import 'package:route_to_market/presentation/bloc/visits/visits_bloc.dart';
import 'package:route_to_market/presentation/components/AppSearchBar.dart';
import 'package:route_to_market/presentation/customers/widgets/visit_widget_card.dart';

import '../components/CustomBox.dart';

class CustomersVisitsPage extends StatefulWidget {
  final Customer customer;

  const CustomersVisitsPage({super.key, required this.customer});

  @override
  State<CustomersVisitsPage> createState() => _CustomersVisitsPageState();
}

class _CustomersVisitsPageState extends State<CustomersVisitsPage> {

  @override
  void initState() {
    super.initState();
    context.read<VisitsBloc>().add(GetCustomerVisits(id: widget.customer.id));
  }
  bool isSearching = false;
  bool isFiltering = false;
  List<OrderFilters> menuItems = [
    OrderFilters(name: "Ascending", ascending: true, icon: Icons.arrow_upward),
    OrderFilters(name: "Descending", ascending: false, icon: Icons.arrow_downward),
  ];
  TextEditingController searchController = TextEditingController();

  VisitFilters filters = VisitFilters();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isSearching,
        title:
            isSearching
                ? AppSearchBar(
                  controller: searchController,
                  onChanged: (searchParam) {
                    filters = filters.copyWith(searchParam: searchParam);
                    context.read<VisitsBloc>().add(
                      FilterCustomerVisits(
                        filters: filters,
                        id: widget.customer.id,
                      ),
                    );
                  },
                )
                : Text(
                  "${widget.customer.name} visits",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
            icon: Icon(isSearching ? Icons.close : Icons.search),
          ),

          if (!isSearching)
            PopupMenuButton<OrderFilters>(
              icon: const Icon(Icons.filter_alt),
              onSelected: (OrderFilters selected) {
                setState(() {
                  isFiltering = !isFiltering;

                  filters = filters.copyWith(ascending: selected.ascending);
                  context.read<VisitsBloc>().add(
                    FilterCustomerVisits(
                      filters: filters,
                      id: widget.customer.id,
                    ),
                  );
                });
              },
              onCanceled: () {
                setState(() {
                  isFiltering = !isFiltering;
                });
              },
              itemBuilder: (BuildContext context) {
                return menuItems
                    .map(
                      (item) => PopupMenuItem<OrderFilters>(
                        value: item,
                        child: Row(
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList();
              },
            ),
        ],
      ),
      body: BlocBuilder<VisitsBloc, VisitsState>(
        builder: (context, state) {
          if (state.status == VisitsStatus.loading &&
              state.customerVisits.isEmpty) {
            return const CenteredColumn(
              content: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.status == VisitsStatus.error &&
              state.customerVisits.isEmpty) {
            return CenteredColumn(content: Text(state.message));
          }

          List<Visit> visits = state.customerVisits.toList();

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: ListView.separated(
                itemCount: visits.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  Visit visit = visits[index];
                  return buildVisitCard(visit);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
