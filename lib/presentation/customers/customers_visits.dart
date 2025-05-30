import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';
import 'package:route_to_market/domain/models/visit/visit_filters.dart';
import 'package:route_to_market/presentation/bloc/visits/visits_bloc.dart';
import 'package:route_to_market/presentation/components/app_search_bar.dart';
import 'package:route_to_market/presentation/customers/widgets/visit_widget_card.dart';

import '../components/custom_box.dart';

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
  bool showVisitActivities = false;

  List<OrderFilters> menuItems = [
    OrderFilters(name: "Ascending", ascending: true, icon: Icons.arrow_upward),
    OrderFilters(
      name: "Descending",
      ascending: false,
      icon: Icons.arrow_downward,
    ),
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

          if (state.status == VisitsStatus.error &&
              state.customerVisits.isEmpty) {
            return CenteredColumn(content: Text(state.message));
          }

          List<Visit> visits = state.customerVisits.toList();

          int pendingVisitsCount =
              visits
                  .where(
                    (visit) =>
                        visit.status.toLowerCase() ==
                        NewVisitStatus.pending.name,
                  )
                  .length;
          int cancelledVisitsCount =
              visits
                  .where(
                    (visit) =>
                        visit.status.toLowerCase() ==
                        NewVisitStatus.cancelled.name,
                  )
                  .length;
          int completedVisitsCount =
              visits
                  .where(
                    (visit) =>
                        visit.status.toLowerCase() ==
                        NewVisitStatus.completed.name,
                  )
                  .length;

          List<VisitDto> offlineVisits =
              state.offlineVisits
                  .where((e) => e.customerId == widget.customer.id)
                  .toList();

          if (state.visits.isEmpty && state.offlineVisits.isEmpty) {
            return CenteredColumn(
              content: Text("No visits found for ${widget.customer.name}"),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              children: [
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildStatCard(
                      label: "Completed",
                      value: "$completedVisitsCount",
                      color: Colors.green[800]!,
                      onClick: () {
                        setState(() {
                          if (filters.status == "Completed") {
                            filters = filters.copyWith(status: null);
                          } else {
                            filters = filters.copyWith(status: filters.status);
                          }
                        });

                        context.read<VisitsBloc>().add(
                          FilterCustomerVisits(
                            filters: filters,
                            id: widget.customer.id,
                          ),
                        );
                      },
                      selected: filters.status == "Completed",
                    ),
                    buildStatCard(
                      label: "Pending  ",
                      value: "$pendingVisitsCount",
                      color: Colors.yellow[800]!,
                      onClick: () {
                        setState(() {
                          if (filters.status == "Pending") {
                            filters = filters.copyWith(status: null);
                          } else {
                            filters = filters.copyWith(status: filters.status);
                          }
                        });

                        context.read<VisitsBloc>().add(
                          FilterCustomerVisits(
                            filters: filters,
                            id: widget.customer.id,
                          ),
                        );
                      },
                      selected: filters.status == "Pending",
                    ),
                    buildStatCard(
                      label: "Cancelled",
                      value: "$cancelledVisitsCount",
                      color: Colors.red[800]!,
                      onClick: () {
                        setState(() {
                          if (filters.status == "Cancelled") {
                            filters = filters.copyWith(status: null);
                          } else {
                            filters = filters.copyWith(status: filters.status);
                          }
                          context.read<VisitsBloc>().add(
                            FilterCustomerVisits(
                              filters: filters,
                              id: widget.customer.id,
                            ),
                          );
                        });
                      },
                      selected: filters.status == "Cancelled",
                    ),
                  ],
                ),

                offlineVisits.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "Unsynced Visits",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        ...offlineVisits.map((offlineVisit) {
                          Visit visit = Visit(
                            id: 1,
                            customerId: offlineVisit.customerId,
                            visitDate: offlineVisit.visitDate,
                            status: offlineVisit.status,
                            location: offlineVisit.location,
                            notes: offlineVisit.notes,
                          );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: buildVisitCard(
                              visit,
                              widget.customer,
                              context,
                            ),
                          );
                        }),
                        Text(
                          "Synced Visits",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    )
                    : SizedBox(),

                const SizedBox(height: 16),
                ...visits.map(
                  (visit) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: buildVisitCard(visit, widget.customer, context),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
