import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/components/AppButton.dart';
import 'package:route_to_market/presentation/components/AppTextField.dart';
import 'package:route_to_market/presentation/components/CustomBox.dart';

import '../../domain/models/customer/Customer.dart';
import 'activity_card.dart';

class CustomerVisitPage extends StatefulWidget {
  final Customer customer;

  const CustomerVisitPage({super.key, required this.customer});

  @override
  State<CustomerVisitPage> createState() => _CustomerVisitPageState();
}

class _CustomerVisitPageState extends State<CustomerVisitPage> {
  TextEditingController notesController = TextEditingController();
  List<int> selectedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.customer.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),

        child: Stack(
          children: [
            ListView(
              children: [
                AppTextField(
                  label: "Notes",
                  maxLines: 5,
                  textInputType: TextInputType.text,
                  icon: null,
                  controller: notesController,
                ),

                Text(
                  "Select activities to complete",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Expanded(
                  child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
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
                                selected: selectedActivities.contains(
                                  activity.id,
                                ),
                                onClick: () {
                                  setState(() {
                                    if (selectedActivities.contains(
                                      activity.id,
                                    )) {
                                      selectedActivities.remove(activity.id);
                                    } else {
                                      selectedActivities.add(activity.id);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 64,
              child:


              AppButton(onClick: () => {}, content: Text("Submit")),
            ),
          ],
        ),
      ),
    );
  }
}
