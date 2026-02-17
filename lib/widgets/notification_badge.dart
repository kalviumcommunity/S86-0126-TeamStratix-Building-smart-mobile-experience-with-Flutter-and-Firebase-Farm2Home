import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return child;
    }

    return badges.Badge(
      badgeContent: Text(
        count > 99 ? '99+' : count.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      badgeStyle: const badges.BadgeStyle(
        badgeColor: Colors.red,
        padding: EdgeInsets.all(6),
      ),
      child: child,
    );
  }
}
