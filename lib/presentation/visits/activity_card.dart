import 'package:flutter/material.dart';
import 'package:route_to_market/domain/models/activity/activity.dart';
import 'package:route_to_market/utils/utils.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool selected;
  final VoidCallback onClick;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onClick,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDateTime(activity.createdAt),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
              Expanded(child: SizedBox()),
              Checkbox(value: selected, onChanged: (_) => onClick()),
            ],
          ),
        ),
      ),
    );
  }
}
