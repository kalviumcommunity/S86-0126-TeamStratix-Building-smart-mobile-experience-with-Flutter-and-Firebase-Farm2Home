import 'package:flutter/material.dart';
import 'interactive_widgets.dart';

/// A reusable product card widget for displaying product information
/// 
/// This comprehensive widget encapsulates all product display logic
/// including image, title, price, rating, and action buttons.
/// Perfect example of building complex reusable components.
/// 
/// Example usage:
/// ```dart
/// ProductCard(
///   imageUrl: 'assets/product.jpg',
///   title: 'Fresh Tomatoes',
///   price: 45.99,
///   rating: 4.5,
///   reviewCount: 23,
///   onAddToCart: () => _addToCart(),
///   onFavorite: (liked) => _toggleFavorite(liked),
/// )
/// ```
class ProductCard extends StatelessWidget {
  /// URL or asset path for the product image
  final String imageUrl;
  
  /// Product name/title
  final String title;
  
  /// Product price
  final double price;
  
  /// Optional product description
  final String? description;
  
  /// Product rating (0-5)
  final double rating;
  
  /// Number of reviews
  final int reviewCount;
  
  /// Callback when add to cart button is pressed
  final VoidCallback? onAddToCart;
  
  /// Callback when product card is tapped
  final VoidCallback? onTap;
  
  /// Callback when favorite button is toggled
  final ValueChanged<bool>? onFavorite;
  
  /// Whether the product is initially favorited
  final bool isFavorited;
  
  /// Optional discount percentage
  final int? discountPercent;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.description,
    this.rating = 0,
    this.reviewCount = 0,
    this.onAddToCart,
    this.onTap,
    this.onFavorite,
    this.isFavorited = false,
    this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with favorite button overlay
            _buildImageSection(),
            
            // Product details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  // Description (if provided)
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  const SizedBox(height: 8),
                  
                  // Rating
                  if (reviewCount > 0)
                    RatingWidget(
                      rating: rating,
                      reviewCount: reviewCount,
                      size: 14,
                    ),
                  
                  const SizedBox(height: 8),
                  
                  // Price and Add to Cart button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPriceSection(),
                      if (onAddToCart != null) _buildAddToCartButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the image section with favorite button
  Widget _buildImageSection() {
    return Stack(
      children: [
        // Product image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  )
                : Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      );
                    },
                  ),
          ),
        ),
        
        // Discount badge
        if (discountPercent != null && discountPercent! > 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '-$discountPercent%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        
        // Favorite button
        if (onFavorite != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: LikeButton(
                initiallyLiked: isFavorited,
                onLikeChanged: onFavorite,
                size: 20,
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the price display with discount if applicable
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
        if (discountPercent != null && discountPercent! > 0) ...[
          const SizedBox(height: 2),
          Text(
            '\$${(price * (100 + discountPercent!) / 100).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the add to cart button
  Widget _buildAddToCartButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.add_shopping_cart),
        color: Colors.white,
        iconSize: 20,
        onPressed: onAddToCart,
        tooltip: 'Add to cart',
      ),
    );
  }
}

/// A compact version of ProductCard for list views
/// 
/// Horizontal layout optimized for ListView items
class ProductCardCompact extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double price;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const ProductCardCompact({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.rating = 0,
    this.onTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    RatingWidget(rating: rating, size: 12),
                    const SizedBox(height: 4),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Add button
              if (onAddToCart != null)
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  color: Colors.green.shade700,
                  onPressed: onAddToCart,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
