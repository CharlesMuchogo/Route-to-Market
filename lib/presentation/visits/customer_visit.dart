import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/dto/visit_dto.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/bloc/visits/visits_bloc.dart';
import 'package:route_to_market/presentation/components/app_button.dart';
import 'package:route_to_market/presentation/components/app_text_field.dart';
import 'package:route_to_market/presentation/components/custom_box.dart';
import 'package:route_to_market/presentation/customers/customers_visits.dart';

import '../../domain/models/customer/customer.dart';
import '../components/app_snack_bar.dart';
import 'activity_card.dart';

class CustomerVisitPage extends StatefulWidget {
  final Customer customer;

  const CustomerVisitPage({super.key, required this.customer});

  @override
  State<CustomerVisitPage> createState() => _CustomerVisitPageState();
}

class _CustomerVisitPageState extends State<CustomerVisitPage> {
  TextEditingController notesController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  List<int> completedActivities = [];
  String? locationError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          CustomersVisitsPage(customer: widget.customer),
                ),
              );
            },
            icon: Icon(Icons.task),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            ListView(
              children: [
                AppTextField(
                  label: "Notes",
                  minLines: 1,
                  maxLines: 5,
                  hint: "Add notes about your visit",
                  textInputType: TextInputType.text,
                  icon: null,
                  controller: notesController,
                ),

                AppTextField(
                  label: "Location",
                  maxLines: 1,
                  hint: "Add customer location",
                  textInputType: TextInputType.text,
                  error: locationError,
                  icon: null,
                  controller: locationController,
                ),
                const SizedBox(height: 24),
                Text(
                  "Select activities to complete",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                BlocBuilder<ActivitiesBloc, ActivitiesState>(
                  builder: (context, state) {
                    if (state.status == ActivitiesStatus.loading &&
                        state.activities.isEmpty) {
                      return const CenteredColumn(
                        content: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state.status == ActivitiesStatus.error &&
                        state.activities.isEmpty) {
                      return CenteredColumn(content: Text(state.message));
                    }

                    List<Activity> activities =
                        state.activities
                            .map((e) => Activity.fromJson(e))
                            .toList();

                    return Column(
                      children:
                          activities.map((activity) {
                            return ActivityCard(
                              activity: activity,
                              selected: completedActivities.contains(
                                activity.id,
                              ),
                              onClick: () {
                                setState(() {
                                  if (completedActivities.contains(
                                    activity.id,
                                  )) {
                                    completedActivities.remove(activity.id);
                                  } else {
                                    completedActivities.add(activity.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 72),
              ],
            ),
            Positioned(
              right: 2,
              left: 2,
              bottom: 12,
              child: AppButton(
                onClick: () {
                  if (locationController.text.isEmpty) {
                    setState(() {
                      locationError = "Location is required";
                    });
                  } else {
                    VisitDto visitDto = VisitDto(
                      customerId: widget.customer.id,
                      visitDate: DateTime.now(),
                      status: "Pending",
                      location: locationController.text,
                      notes: notesController.text,
                      activitiesDone:
                          completedActivities.map((e) => e.toString()).toList(),
                    );

                    context.read<VisitsBloc>().add(
                      MakeVisit(visitDto: visitDto),
                    );
                  }
                },
                content: BlocConsumer<VisitsBloc, VisitsState>(
                  listener: (context, state) {
                    if (state.status == VisitsStatus.success) {
                      setState(() {
                        locationController.text = "";
                        notesController.text = "";
                        completedActivities = [];
                      });

                      AppSnackBar.show(
                        context,
                        message: state.message,
                        color: Colors.green,
                        icon: Icons.check_circle,
                      );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => CustomersVisitsPage(
                                customer: widget.customer,
                              ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.status == VisitsStatus.submitting) {
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      );
                    }
                    return Text(
                      "Submit",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
