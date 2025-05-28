import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:route_to_market/domain/models/activity/Activity.dart';
import 'package:route_to_market/utils/Utils.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool selected;
  final VoidCallback onClick;

  const ActivityCard({super.key, required this.activity, required this.onClick, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 8),
      child:  GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: getActivityAvatarColor(activity.id),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    getCompanyInitials(activity.description),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Created ${formatDate(activity.createdAt)}',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Expanded(child: SizedBox()),
              Checkbox(value: selected, onChanged: (_) => onClick())
            ],
          ),
        ),
      )

      ,);
  }
}
