import 'package:flutter/material.dart';
import 'package:route_to_market/domain/models/customer/Customer.dart';
import 'package:route_to_market/utils/Utils.dart';



class BuildCustomerInfo extends StatelessWidget {
  final Customer customer;
  final VoidCallback onClick;
  const BuildCustomerInfo({super.key, required this.customer, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: getAvatarColor(customer.id),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                    getCompanyInitials(customer.name),
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
                  customer.name,
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
                      'Created ${formatDate(customer.createdAt)}',
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.normal
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}
