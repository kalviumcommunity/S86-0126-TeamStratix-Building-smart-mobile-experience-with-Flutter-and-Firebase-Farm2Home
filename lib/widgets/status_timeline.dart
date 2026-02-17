import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatusTimeline extends StatelessWidget {
  final String currentStatus;
  final List<String> allStatuses;

  const StatusTimeline({
    super.key,
    required this.currentStatus,
    required this.allStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = allStatuses.indexOf(currentStatus);

    return Column(
      children: List.generate(allStatuses.length, (index) {
        final status = allStatuses[index];
        final isCompleted = index <= currentIndex;
        final isLast = index == allStatuses.length - 1;

        return _buildTimelineItem(
          context,
          status: status,
          isCompleted: isCompleted,
          isLast: isLast,
        );
      }),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context, {
    required String status,
    required bool isCompleted,
    required bool isLast,
  }) {
    final color =
        isCompleted ? AppTheme.getStatusColor(status) : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? color : Colors.white,
                border: Border.all(
                  color: color,
                  width: 3,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 40,
                color: isCompleted ? color : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Status info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? color : Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusDescription(status),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'Received':
        return 'Your order has been received';
      case 'Harvesting':
        return 'Fresh produce is being harvested';
      case 'Packed':
        return 'Your order has been packed';
      case 'Out for Delivery':
        return 'On the way to your location';
      case 'Delivered':
        return 'Order delivered successfully';
      default:
        return '';
    }
  }
}
