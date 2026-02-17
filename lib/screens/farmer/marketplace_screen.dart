import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/crop_listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/farmer_services_hub.dart';
import '../../widgets/loading_widget.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> with SingleTickerProviderStateMixin {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();
  late TabController _tabController;

  // Sample crop listings - displayed on Browse tab
  late final List<Map<String, dynamic>> _sampleListings = [
    {'crop': 'Wheat', 'quantity': 500, 'unit': 'kg', 'price': 28, 'quality': 'Premium', 'region': 'Punjab'},
    {'crop': 'Rice', 'quantity': 1000, 'unit': 'kg', 'price': 45, 'quality': 'A Grade', 'region': 'Haryana'},
    {'crop': 'Cotton', 'quantity': 200, 'unit': 'bales', 'price': 8500, 'quality': 'Premium', 'region': 'Gujarat'},
    {'crop': 'Corn', 'quantity': 750, 'unit': 'kg', 'price': 32, 'quality': 'Good', 'region': 'Madhya Pradesh'},
    {'crop': 'Soybean', 'quantity': 600, 'unit': 'kg', 'price': 42, 'quality': 'Premium', 'region': 'Maharashtra'},
    {'crop': 'Sugarcane', 'quantity': 5000, 'unit': 'kg', 'price': 12, 'quality': 'Premium', 'region': 'Uttar Pradesh'},
    {'crop': 'Tomato', 'quantity': 400, 'unit': 'kg', 'price': 18, 'quality': 'Fresh', 'region': 'Karnataka'},
    {'crop': 'Onion', 'quantity': 800, 'unit': 'kg', 'price': 22, 'quality': 'A Grade', 'region': 'Rajasthan'},
    {'crop': 'Potato', 'quantity': 1200, 'unit': 'kg', 'price': 15, 'quality': 'Premium', 'region': 'Himachal Pradesh'},
    {'crop': 'Chilli Powder', 'quantity': 100, 'unit': 'kg', 'price': 180, 'quality': 'Premium', 'region': 'Telangana'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmerId = authProvider.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Browse'),
            Tab(text: 'My Listings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildMyListingsTab(farmerId),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSellDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Sell Crop'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildBrowseTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _sampleListings.length,
      itemBuilder: (context, index) {
        final listing = _sampleListings[index];
        return _buildListingCard(listing);
      },
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing['crop'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quality: ${listing['quality']} • ${listing['region']}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Available',
                    style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Quantity', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      '${listing['quantity']} ${listing['unit']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Price', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    Text(
                      '₹${listing['price']}/unit',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${listing['crop']} added to cart!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart, size: 16),
                  label: const Text('Buy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyListingsTab(String farmerId) {
    return StreamBuilder<List<CropListing>>(
      stream: _servicesHub.getFarmerListings(farmerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        final listings = snapshot.data ?? [];

        if (listings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No listings yet', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: listings.length,
          itemBuilder: (context, index) => _buildMyListingCard(listings[index]),
        );
      },
    );
  }

  Widget _buildMyListingCard(CropListing listing) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(listing.cropName, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: listing.status == 'available' ? Colors.green.shade100 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    listing.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: listing.status == 'available' ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('₹${listing.pricePerUnit}/${listing.unit} • ${listing.quantity} ${listing.unit} available',
                style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showSellDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Your Crop'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Crop Name', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Quantity', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Price per Unit', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Quality Grade', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Post')),
        ],
      ),
    );
  }
}
