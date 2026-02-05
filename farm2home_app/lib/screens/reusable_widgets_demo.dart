import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/interactive_widgets.dart';
import '../widgets/product_card.dart';

/// Demonstrates the use of custom reusable widgets across the app
/// 
/// This screen showcases various custom widgets and their reusability:
/// - InfoCard for displaying information
/// - CustomButton with different variants
/// - LikeButton for interactive favorites
/// - ProductCard for product displays
/// - RatingWidget for star ratings
class ReusableWidgetsDemo extends StatefulWidget {
  const ReusableWidgetsDemo({super.key});

  @override
  State<ReusableWidgetsDemo> createState() => _ReusableWidgetsDemoState();
}

class _ReusableWidgetsDemoState extends State<ReusableWidgetsDemo> {
  final bool _showSnackbar = true;
  int _buttonPressCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reusable Widgets Demo'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Introduction card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.widgets, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Custom Reusable Widgets',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This screen demonstrates various custom widgets that can be reused throughout the app. Each widget is modular, customizable, and maintains design consistency.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 1: InfoCard widgets
          _buildSectionHeader('1. InfoCard Widgets', Icons.info),
          const Text(
            'Reusable information cards with icons, titles, and subtitles:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          
          InfoCard(
            title: 'Profile',
            subtitle: 'View and edit your personal information',
            icon: Icons.person,
            iconColor: Colors.blue,
            onTap: () => _showMessage('Profile tapped!'),
          ),
          
          InfoCard(
            title: 'Settings',
            subtitle: 'Manage app preferences and notifications',
            icon: Icons.settings,
            iconColor: Colors.purple,
            onTap: () => _showMessage('Settings tapped!'),
          ),
          
          InfoCard(
            title: 'Orders',
            subtitle: 'Track your order history and deliveries',
            icon: Icons.shopping_bag,
            iconColor: Colors.green,
            onTap: () => _showMessage('Orders tapped!'),
          ),
          
          const SizedBox(height: 24),
          
          // Section 2: Custom Buttons
          _buildSectionHeader('2. CustomButton Variants', Icons.smart_button),
          const Text(
            'Different button styles with consistent design:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          
          CustomButton(
            text: 'Primary Button',
            onPressed: () => _handleButtonPress('Primary'),
            variant: ButtonVariant.primary,
            icon: Icons.check,
            fullWidth: true,
          ),
          
          const SizedBox(height: 12),
          
          CustomButton(
            text: 'Secondary Button',
            onPressed: () => _handleButtonPress('Secondary'),
            variant: ButtonVariant.secondary,
            icon: Icons.star,
            fullWidth: true,
          ),
          
          const SizedBox(height: 12),
          
          CustomButton(
            text: 'Outlined Button',
            onPressed: () => _handleButtonPress('Outlined'),
            variant: ButtonVariant.outlined,
            icon: Icons.favorite_border,
            fullWidth: true,
          ),
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                text: 'Cancel',
                onPressed: () => _handleButtonPress('Cancel'),
                variant: ButtonVariant.text,
              ),
              CustomButton(
                text: 'Loading',
                onPressed: () {},
                variant: ButtonVariant.primary,
                isLoading: true,
              ),
            ],
          ),
          
          if (_buttonPressCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Buttons pressed: $_buttonPressCount times',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Section 3: Interactive Widgets
          _buildSectionHeader('3. Interactive Widgets', Icons.touch_app),
          const Text(
            'Stateful widgets with user interaction:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Like Buttons (Stateful)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          LikeButton(
                            onLikeChanged: (liked) {
                              _showMessage(liked ? 'Liked! ❤️' : 'Unliked');
                            },
                            size: 40,
                          ),
                          const SizedBox(height: 4),
                          const Text('Default', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          LikeButton(
                            initiallyLiked: true,
                            onLikeChanged: (liked) {
                              _showMessage(liked ? 'Liked! 💚' : 'Unliked');
                            },
                            likedColor: Colors.green,
                            size: 40,
                          ),
                          const SizedBox(height: 4),
                          const Text('Green', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Column(
                        children: [
                          LikeButton(
                            onLikeChanged: (liked) {
                              _showMessage(liked ? 'Liked! 💜' : 'Unliked');
                            },
                            likedColor: Colors.purple,
                            size: 40,
                          ),
                          const SizedBox(height: 4),
                          const Text('Purple', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    'Rating Widgets',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const RatingWidget(rating: 5.0, reviewCount: 245, size: 20),
                  const SizedBox(height: 8),
                  const RatingWidget(rating: 4.5, reviewCount: 128, size: 18),
                  const SizedBox(height: 8),
                  const RatingWidget(rating: 3.5, reviewCount: 45),
                  const SizedBox(height: 8),
                  const RatingWidget(rating: 2.0, reviewCount: 12),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Section 4: Product Cards
          _buildSectionHeader('4. Product Card Widgets', Icons.shopping_cart),
          const Text(
            'Complex reusable components for product display:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          
          // Grid of product cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: [
              ProductCard(
                imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                title: 'Fresh Salad',
                description: 'Organic mixed greens',
                price: 12.99,
                rating: 4.8,
                reviewCount: 156,
                discountPercent: 15,
                onTap: () => _showMessage('Product tapped!'),
                onAddToCart: () => _showMessage('Added to cart!'),
                onFavorite: (liked) => _showMessage(liked ? 'Added to favorites!' : 'Removed from favorites'),
              ),
              ProductCard(
                imageUrl: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea',
                title: 'Fresh Tomatoes',
                description: 'Locally grown',
                price: 5.99,
                rating: 4.5,
                reviewCount: 89,
                isFavorited: true,
                onTap: () => _showMessage('Product tapped!'),
                onAddToCart: () => _showMessage('Added to cart!'),
                onFavorite: (liked) => _showMessage(liked ? 'Added to favorites!' : 'Removed from favorites'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Compact product cards
          const Text(
            'Compact variant for list views:',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          
          ProductCardCompact(
            imageUrl: 'https://images.unsplash.com/photo-1449198063792-7d754d6f3c80',
            title: 'Fresh Carrots',
            price: 3.99,
            rating: 4.2,
            onTap: () => _showMessage('Compact product tapped!'),
            onAddToCart: () => _showMessage('Added to cart!'),
          ),
          
          ProductCardCompact(
            imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655',
            title: 'Green Peppers',
            price: 4.50,
            rating: 4.7,
            onTap: () => _showMessage('Compact product tapped!'),
            onAddToCart: () => _showMessage('Added to cart!'),
          ),
          
          const SizedBox(height: 24),
          
          // Benefits summary
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Benefits of Reusable Widgets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBenefitItem('Code Reusability', 'Write once, use everywhere'),
                  _buildBenefitItem('Consistency', 'Uniform design across app'),
                  _buildBenefitItem('Maintainability', 'Update once, reflect everywhere'),
                  _buildBenefitItem('Scalability', 'Easy to extend and modify'),
                  _buildBenefitItem('Team Collaboration', 'Clear component boundaries'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonPress(String buttonType) {
    setState(() {
      _buttonPressCount++;
    });
    _showMessage('$buttonType button pressed!');
  }

  void _showMessage(String message) {
    if (!_showSnackbar) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
