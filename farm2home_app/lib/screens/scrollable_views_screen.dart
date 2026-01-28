import 'package:flutter/material.dart';

/// Scrollable Views Screen demonstrating ListView and GridView
class ScrollableViewsScreen extends StatelessWidget {
  const ScrollableViewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Scrollable Views Demo'),
        backgroundColor: const Color(0xFF4A7C4A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Vertical ListView
            _buildSectionHeader('ListView - Vertical Scrolling'),
            _buildVerticalListView(),
            
            const Divider(thickness: 2, height: 32),
            
            // Section 2: Horizontal ListView
            _buildSectionHeader('ListView - Horizontal Scrolling'),
            _buildHorizontalListView(),
            
            const Divider(thickness: 2, height: 32),
            
            // Section 3: GridView
            _buildSectionHeader('GridView - Grid Layout'),
            _buildGridView(),
            
            const Divider(thickness: 2, height: 32),
            
            // Section 4: Dynamic ListView with Builder
            _buildSectionHeader('ListView.builder - Dynamic Data'),
            _buildDynamicListView(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Section header widget
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF4A7C4A).withValues(alpha: 0.1),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D5A2D),
        ),
      ),
    );
  }

  /// Vertical ListView with ListTiles
  Widget _buildVerticalListView() {
    final List<Map<String, dynamic>> users = [
      {'name': 'John Farmer', 'status': 'Online', 'role': 'Vegetable Supplier', 'icon': Icons.person},
      {'name': 'Sarah Green', 'status': 'Online', 'role': 'Fruit Supplier', 'icon': Icons.person_outline},
      {'name': 'Mike Brown', 'status': 'Offline', 'role': 'Dairy Products', 'icon': Icons.person},
      {'name': 'Emma Wilson', 'status': 'Online', 'role': 'Organic Farm', 'icon': Icons.person_outline},
      {'name': 'David Lee', 'status': 'Offline', 'role': 'Grain Supplier', 'icon': Icons.person},
    ];

    return Container(
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final user = users[index];
          final isOnline = user['status'] == 'Online';
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4A7C4A),
              child: Icon(
                user['icon'] as IconData,
                color: Colors.white,
              ),
            ),
            title: Text(
              user['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(user['role'] as String),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                user['status'] as String,
                style: TextStyle(
                  color: isOnline ? Colors.green.shade700 : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on ${user['name']}')),
              );
            },
          );
        },
      ),
    );
  }

  /// Horizontal ListView with Cards
  Widget _buildHorizontalListView() {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Vegetables', 'icon': Icons.eco, 'color': Colors.green},
      {'name': 'Fruits', 'icon': Icons.apple, 'color': Colors.red},
      {'name': 'Dairy', 'icon': Icons.local_drink, 'color': Colors.blue},
      {'name': 'Grains', 'icon': Icons.grass, 'color': Colors.amber},
      {'name': 'Organic', 'icon': Icons.verified, 'color': Colors.teal},
      {'name': 'Fresh', 'icon': Icons.local_florist, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = category['color'] as Color;
          
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.8),
                  color.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// GridView with product tiles
  Widget _buildGridView() {
    final List<Map<String, dynamic>> products = [
      {'name': 'Tomatoes', 'price': 3.99, 'icon': '🍅', 'color': Colors.red},
      {'name': 'Lettuce', 'price': 2.49, 'icon': '🥬', 'color': Colors.green},
      {'name': 'Carrots', 'price': 1.99, 'icon': '🥕', 'color': Colors.orange},
      {'name': 'Apples', 'price': 4.99, 'icon': '🍎', 'color': Colors.red},
      {'name': 'Milk', 'price': 3.49, 'icon': '🥛', 'color': Colors.blue},
      {'name': 'Eggs', 'price': 5.99, 'icon': '🥚', 'color': Colors.amber},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: (product['color'] as Color).withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          product['icon'] as String,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${(product['price'] as num).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7C4A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A7C4A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Dynamic ListView.builder with many items
  Widget _buildDynamicListView() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 20,
        itemBuilder: (context, index) {
          final icons = [
            Icons.shopping_basket,
            Icons.local_shipping,
            Icons.payment,
            Icons.verified_user,
            Icons.notifications,
          ];
          
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF4A7C4A).withValues(alpha: 0.2),
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A7C4A),
                ),
              ),
            ),
            title: Text('Dynamic Item ${index + 1}'),
            subtitle: Text('This is dynamically generated item number ${index + 1}'),
            trailing: Icon(
              icons[index % icons.length],
              color: const Color(0xFF4A7C4A),
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}
