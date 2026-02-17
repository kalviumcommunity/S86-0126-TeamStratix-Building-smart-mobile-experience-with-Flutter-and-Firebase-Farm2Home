import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FarmerRatingWidget extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final double size;

  const FarmerRatingWidget({
    super.key,
    required this.rating,
    required this.totalRatings,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: size,
          direction: Axis.horizontal,
        ),
        const SizedBox(width: 4),
        Text(
          '${rating.toStringAsFixed(1)} ($totalRatings)',
          style: TextStyle(
            fontSize: size * 0.8,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
