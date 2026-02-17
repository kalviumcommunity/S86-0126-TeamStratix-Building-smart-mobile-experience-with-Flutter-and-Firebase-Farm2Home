import 'package:flutter/material.dart';
import '../core/app_breakpoints.dart';

class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.all(context.responsivePadding);
    final defaultMargin = const EdgeInsets.all(AppSpacing.cardMargin);

    return Card(
      elevation: elevation ?? 2,
      color: color,
      margin: margin ?? defaultMargin,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ??
            BorderRadius.circular(AppSpacing.cardBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppSpacing.cardBorderRadius),
        child: Padding(
          padding: padding ?? defaultPadding,
          child: child,
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).primaryColor;

    return ResponsiveCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ),
              Icon(icon, color: cardColor, size: 24),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? color;
  final VoidCallback? onDismiss;

  const InfoCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.color,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Colors.blue;

    return ResponsiveCard(
      color: cardColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(icon, color: cardColor, size: 40),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cardColor,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: onDismiss,
              color: cardColor,
            ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).primaryColor;

    return ResponsiveCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: cardColor),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }
}
