import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/presentation/activities/widgets/activity_screen_card.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/components/CustomBox.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivitiesBloc, ActivitiesState>(
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
          state.activities.map((e) => Activity.fromJson(e)).toList();

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                Activity activity = activities[index];
                return ActivityScreenCard(
                  activity: activity,
                  onClick: () {
                  },
                );
              },
            ),
          );
        },
      );
  }
}
