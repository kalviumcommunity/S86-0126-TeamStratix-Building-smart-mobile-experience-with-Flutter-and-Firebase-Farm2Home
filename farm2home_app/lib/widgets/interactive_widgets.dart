import 'package:flutter/material.dart';

/// A reusable stateful widget for a like/favorite button
/// 
/// This widget demonstrates how stateful custom widgets can manage
/// their own internal state while being reused across multiple screens.
/// The button toggles between liked and unliked states with smooth animations.
/// 
/// Example usage:
/// ```dart
/// LikeButton(
///   initiallyLiked: false,
///   onLikeChanged: (isLiked) {
///     print('Like status: $isLiked');
///   },
/// )
/// ```
class LikeButton extends StatefulWidget {
  /// Whether the button starts in liked state
  final bool initiallyLiked;
  
  /// Callback function that receives the new like status
  final ValueChanged<bool>? onLikeChanged;
  
  /// Optional custom size for the button
  final double size;
  
  /// Optional custom color when liked
  final Color? likedColor;

  const LikeButton({
    super.key,
    this.initiallyLiked = false,
    this.onLikeChanged,
    this.size = 32,
    this.likedColor,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late bool _isLiked;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.initiallyLiked;
    
    // Setup animation controller for smooth scaling effect
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    // Trigger animation
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    // Notify parent widget of change
    widget.onLikeChanged?.call(_isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked
              ? (widget.likedColor ?? Colors.red)
              : Colors.grey.shade400,
          size: widget.size,
        ),
      ),
    );
  }
}

/// A reusable rating display widget
/// 
/// Shows a star rating with optional review count.
/// Can be used in product cards, review sections, etc.
/// 
/// Example usage:
/// ```dart
/// RatingWidget(
///   rating: 4.5,
///   reviewCount: 128,
/// )
/// ```
class RatingWidget extends StatelessWidget {
  /// The rating value (0-5)
  final double rating;
  
  /// Optional number of reviews
  final int? reviewCount;
  
  /// Size of the star icons
  final double size;
  
  /// Color for filled stars
  final Color? starColor;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
    this.starColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            // Full star
            return Icon(
              Icons.star,
              size: size,
              color: starColor ?? Colors.amber,
            );
          } else if (index < rating) {
            // Half star
            return Icon(
              Icons.star_half,
              size: size,
              color: starColor ?? Colors.amber,
            );
          } else {
            // Empty star
            return Icon(
              Icons.star_border,
              size: size,
              color: starColor ?? Colors.amber,
            );
          }
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size * 0.875,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}
