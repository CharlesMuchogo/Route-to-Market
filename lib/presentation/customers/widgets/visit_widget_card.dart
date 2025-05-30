import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/domain/models/customer/customer.dart';
import 'package:route_to_market/domain/models/visit/visit.dart';
import 'package:route_to_market/presentation/bloc/activities/activities_bloc.dart';
import 'package:route_to_market/presentation/customers/widgets/visit_activities_dialog.dart';

Widget buildStatCard({
  required String label,
  required String value,
  required Color color,
  required VoidCallback onClick,
  required bool selected,
}) {
  return InkWell(
    onTap: onClick,
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.grey[200]! : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    ),
  );
}

Widget buildVisitCard(Visit visit, Customer customer, BuildContext context) {
  List<int> activitiesDone =
      (visit.activitiesDone ?? [])
          .map((activity) => int.tryParse(activity))
          .where((value) => value != null)
          .cast<int>()
          .toList();

  return BlocBuilder<ActivitiesBloc, ActivitiesState>(
    builder: (context, state) {
      /** Filter the activities here for consistency in the UI */
      List<Activity> allActivities =
          state.activities
              .map((activity) => Activity.fromJson(activity))
              .toList();

      List<Activity> visitActivities =
          allActivities
              .where((activity) => activitiesDone.contains(activity.id))
              .toList();

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[500]),
                    SizedBox(width: 8),
                    Text(
                      customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(visit.status),
              ],
            ),
            SizedBox(height: 12),

            // Date and Time
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                SizedBox(width: 8),
                Text(
                  _formatDate(visit.visitDate),
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    visit.location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),

            // Notes
            if (visit.notes.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  visit.notes,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            ],

            SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => ShowVisitActivitiesDialog(
                            /** Pass filtered activities list here for consistency */
                            visitActivities: visitActivities,
                          ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 4),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      /** Use filtered activities list here for consistency */
                      '${visitActivities.length} Activit${visitActivities.length == 1 ? 'y' : 'ies'} completed',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ),
                Text(
                  'Visit #${visit.id}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildStatusBadge(String status) {
  Color backgroundColor;
  Color textColor;
  Color borderColor;
  IconData icon;

  switch (status.toLowerCase()) {
    case 'completed':
      backgroundColor = Colors.green[100]!;
      textColor = Colors.green[800]!;
      borderColor = Colors.green[200]!;
      icon = Icons.check_circle;
      break;
    case 'pending':
      backgroundColor = Colors.yellow[100]!;
      textColor = Colors.yellow[800]!;
      borderColor = Colors.yellow[200]!;
      icon = Icons.access_time;
      break;
    case 'cancelled':
      backgroundColor = Colors.red[100]!;
      textColor = Colors.red[800]!;
      borderColor = Colors.red[200]!;
      icon = Icons.cancel;
      break;
    default:
      backgroundColor = Colors.grey[100]!;
      textColor = Colors.grey[800]!;
      borderColor = Colors.grey[200]!;
      icon = Icons.help_outline;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: borderColor),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: textColor),
        SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

String _formatDate(DateTime date) {
  final months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final hour =
      date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
  final period = date.hour >= 12 ? 'PM' : 'AM';
  final minute = date.minute.toString().padLeft(2, '0');

  return '${months[date.month - 1]} ${date.day}, ${date.year} at $hour:$minute $period';
}
