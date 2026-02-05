import 'package:flutter/material.dart';

/// A reusable information card widget that displays an icon, title, and subtitle
/// 
/// This stateless widget provides a consistent card design across the app.
/// It can be used to display menu items, features, or any information
/// that needs visual emphasis.
/// 
/// Example usage:
/// ```dart
/// InfoCard(
///   title: 'Profile',
///   subtitle: 'View your details',
///   icon: Icons.person,
///   onTap: () => Navigator.pushNamed(context, '/profile'),
/// )
/// ```
class InfoCard extends StatelessWidget {
  /// The main title text displayed in the card
  final String title;
  
  /// The subtitle or description text displayed below the title
  final String subtitle;
  
  /// The icon displayed on the left side of the card
  final IconData icon;
  
  /// Optional callback function when the card is tapped
  final VoidCallback? onTap;
  
  /// Optional custom color for the icon (defaults to teal)
  final Color? iconColor;
  
  /// Optional custom background color for the card
  final Color? backgroundColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 3,
      color: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon container with background
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.teal).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.teal,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon if tappable
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
