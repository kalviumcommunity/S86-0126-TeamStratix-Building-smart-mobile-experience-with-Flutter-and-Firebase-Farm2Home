import 'package:flutter/material.dart';

/// Animated Product Card with hover and tap animations
class AnimatedProductCard extends StatefulWidget {
  final String title;
  final double price;
  final String imageAsset;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const AnimatedProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageAsset,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _setHovered(bool hovered) {
    if (hovered != _isHovered) {
      _isHovered = hovered;
      hovered ? _hoverController.forward() : _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.05).animate(
            CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Container with Opacity Animation
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Placeholder icon with fade animation
                        AnimatedOpacity(
                          opacity: _isHovered ? 0.5 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.shopping_basket,
                            size: 48,
                            color: Colors.green[400],
                          ),
                        ),
                        // Overlay on hover
                        if (_isHovered)
                          Container(color: Colors.black.withValues(alpha: 0.2)),
                      ],
                    ),
                  ),
                ),
                // Product Info
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Price with animated text color
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isHovered
                              ? Colors.green[600]
                              : Colors.green[400],
                        ),
                        child: Text('₹${widget.price.toStringAsFixed(2)}'),
                      ),
                      const SizedBox(height: 12),
                      // Add to Cart Button with scale animation
                      ScaleTransition(
                        scale: Tween<double>(begin: 1.0, end: 0.95).animate(
                          CurvedAnimation(
                            parent: _hoverController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: widget.onAddToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[500],
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
