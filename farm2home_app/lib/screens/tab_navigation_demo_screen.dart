import 'package:flutter/material.dart';

/// Basic tab navigation demonstration using BottomNavigationBar
///
/// This screen demonstrates the simplest implementation of tab navigation
/// using Flutter's BottomNavigationBar widget with state management.
class TabNavigationDemoScreen extends StatefulWidget {
  const TabNavigationDemoScreen({super.key});

  @override
  State<TabNavigationDemoScreen> createState() =>
      _TabNavigationDemoScreenState();
}

class _TabNavigationDemoScreenState extends State<TabNavigationDemoScreen> {
  int _currentIndex = 0;

  // Define screens for each tab
  final List<Widget> _screens = [
    const _HomeTabContent(),
    const _SearchTabContent(),
    const _FavoritesTabContent(),
    const _ProfileTabContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Tab Navigation'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Home tab content
class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, size: 80, color: Colors.green[700]),
            const SizedBox(height: 24),
            Text(
              'Home Screen',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is the home tab content.',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildFeatureCard(
              context,
              'Fresh Products',
              'Browse our selection of farm-fresh produce',
              Icons.shopping_basket,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Quick Delivery',
              'Get your order delivered within 24 hours',
              Icons.delivery_dining,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700], size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

/// Search tab content
class _SearchTabContent extends StatefulWidget {
  const _SearchTabContent();

  @override
  State<_SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends State<_SearchTabContent> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _products = [
    'Tomatoes',
    'Carrots',
    'Lettuce',
    'Cucumbers',
    'Peppers',
    'Onions',
    'Potatoes',
    'Broccoli',
  ];
  List<String> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _products;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where(
              (product) => product.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green[700],
          child: TextField(
            controller: _searchController,
            onChanged: _filterProducts,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: _filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green[100],
                        child: Icon(
                          Icons.shopping_bag,
                          color: Colors.green[700],
                        ),
                      ),
                      title: Text(_filteredProducts[index]),
                      subtitle: Text(
                        'Fresh organic ${_filteredProducts[index].toLowerCase()}',
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selected: ${_filteredProducts[index]}',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Favorites tab content with state preservation
class _FavoritesTabContent extends StatefulWidget {
  const _FavoritesTabContent();

  @override
  State<_FavoritesTabContent> createState() => _FavoritesTabContentState();
}

class _FavoritesTabContentState extends State<_FavoritesTabContent> {
  final List<Map<String, dynamic>> _favorites = [
    {'name': 'Organic Tomatoes', 'price': '\$4.99', 'liked': true},
    {'name': 'Fresh Carrots', 'price': '\$3.49', 'liked': true},
    {'name': 'Green Lettuce', 'price': '\$2.99', 'liked': true},
    {'name': 'Cucumbers', 'price': '\$3.99', 'liked': true},
  ];

  @override
  Widget build(BuildContext context) {
    return _favorites.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start adding items to your favorites',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _favorites.length,
            itemBuilder: (context, index) {
              final item = _favorites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: Icon(Icons.shopping_bag, color: Colors.green[700]),
                  ),
                  title: Text(
                    item['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(item['price']),
                  trailing: IconButton(
                    icon: Icon(
                      item['liked'] ? Icons.favorite : Icons.favorite_border,
                      color: item['liked'] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _favorites.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Removed from favorites'),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() {
                                _favorites.insert(index, item);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
  }
}

/// Profile tab content
class _ProfileTabContent extends StatelessWidget {
  const _ProfileTabContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.green[700],
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'John Farmer',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'john.farmer@example.com',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          _buildProfileOption(
            context,
            Icons.shopping_bag,
            'My Orders',
            'View your order history',
          ),
          _buildProfileOption(
            context,
            Icons.location_on,
            'Addresses',
            'Manage delivery addresses',
          ),
          _buildProfileOption(
            context,
            Icons.payment,
            'Payment Methods',
            'Manage payment options',
          ),
          _buildProfileOption(
            context,
            Icons.notifications,
            'Notifications',
            'Notification preferences',
          ),
          _buildProfileOption(
            context,
            Icons.settings,
            'Settings',
            'App settings and preferences',
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logged out successfully'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $title...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
