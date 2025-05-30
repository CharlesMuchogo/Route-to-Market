import 'package:flutter/material.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/utils/utils.dart';

class ShowVisitActivitiesDialog extends StatelessWidget {
  final List<Activity> visitActivities;

  const ShowVisitActivitiesDialog({super.key, required this.visitActivities});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Reduced from default 20.0
      ),
      title: Text(
        "Activities Completed",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: SingleChildScrollView(
        child:
            visitActivities.isEmpty
                ? Text("No activities completed")
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                      visitActivities
                          .map(
                            (activity) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    activity.description,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    formatDateTime(activity.createdAt),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
      ],
    );
  }
}
