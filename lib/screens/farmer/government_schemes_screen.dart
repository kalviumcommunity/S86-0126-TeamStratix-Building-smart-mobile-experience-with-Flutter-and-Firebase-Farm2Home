import 'package:flutter/material.dart';

class GovernmentSchemesScreen extends StatefulWidget {
  const GovernmentSchemesScreen({super.key});

  @override
  State<GovernmentSchemesScreen> createState() => _GovernmentSchemesScreenState();
}

class _GovernmentSchemesScreenState extends State<GovernmentSchemesScreen> {
  // Government Schemes with images and details
  final List<Map<String, dynamic>> _govtSchemes = [
    {
      'name': 'PM-KISAN',
      'benefit': '₹6,000 per year',
      'description': 'Direct income support to farmers - ₹2,000 in 3 installments',
      'icon': Icons.monetization_on,
      'color': Colors.green,
      'image': 'https://images.unsplash.com/photo-1554224311-beee415c15c7?w=300&h=300&fit=crop',
      'eligibility': 'All landholding farmers',
      'details': 'Pradhan Mantri Kisan Samman Nidhi (PM-KISAN) provides income support to all landholding farmers\' families. ₹6000 per year in three equal installments of ₹2000 each.',
    },
    {
      'name': 'Crop Insurance Scheme',
      'benefit': 'Up to ₹50,000 coverage',
      'description': 'Pradhan Mantri Fasal Bima Yojana - Protection against crop loss',
      'icon': Icons.shield,
      'color': Colors.blue,
      'image': 'https://images.unsplash.com/photo-1507842217343-583f20270319?w=300&h=300&fit=crop',
      'eligibility': 'All farmers growing notified crops',
      'details': 'Comprehensive risk solution for crop loss due to natural calamities, pests, and diseases. Low premium rates with high sum insured.',
    },
    {
      'name': 'Agricultural Subsidy',
      'benefit': '30-50% subsidy',
      'description': 'Subsidies on seeds, fertilizers, equipment & tools',
      'icon': Icons.local_offer,
      'color': Colors.orange,
      'image': 'https://images.unsplash.com/photo-1593642632509-f1d5e6e52c5b?w=300&h=300&fit=crop',
      'eligibility': 'Small and marginal farmers',
      'details': 'Government provides subsidies on farm inputs including seeds, fertilizers, and agricultural machinery to reduce farming costs.',
    },
    {
      'name': 'Soil Health Card',
      'benefit': 'Free soil testing',
      'description': 'Get soil nutrients report & personalized fertilizer recommendations',
      'icon': Icons.eco,
      'color': Colors.amber,
      'image': 'https://images.unsplash.com/photo-1604348155391-56e93b46ba4c?w=300&h=300&fit=crop',
      'eligibility': 'All farmers',
      'details': 'Soil Health Card scheme provides farmers with information on nutrient status of their soil along with recommendations.',
    },
    {
      'name': 'Irrigation Subsidy',
      'benefit': '40-60% cost assistance',
      'description': 'Incentive for drip irrigation & sprinkler systems installation',
      'icon': Icons.water_drop,
      'color': Colors.lightBlue,
      'image': 'https://images.unsplash.com/photo-1625246333195-78d9c38ad576?w=300&h=300&fit=crop',
      'eligibility': 'Farmers with agricultural land',
      'details': 'Pradhan Mantri Krishi Sinchayee Yojana promotes micro-irrigation to improve water use efficiency and increase crop productivity.',
    },
    {
      'name': 'Rural Credit',
      'benefit': 'Low interest loans',
      'description': 'Easy credit with minimal documentation for farm investments',
      'icon': Icons.card_giftcard,
      'color': Colors.purple,
      'image': 'https://images.unsplash.com/photo-1606857521220-dfa74ec641a7?w=300&h=300&fit=crop',
      'eligibility': 'Farmers and rural entrepreneurs',
      'details': 'Kisan Credit Card (KCC) provides adequate and timely credit support for agriculture and allied activities with low interest rates.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Schemes'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.withOpacity(0.8),
                      Colors.teal.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.badge, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Government Schemes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Avail benefits you are eligible for',
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Available Schemes (${_govtSchemes.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Government Schemes Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _govtSchemes.length,
                itemBuilder: (context, index) {
                  final scheme = _govtSchemes[index];
                  return _buildSchemeCard(scheme);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, dynamic> scheme) {
    return InkWell(
      onTap: () => _showSchemeDetails(scheme),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    scheme['image'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 100,
                      color: (scheme['color'] as Color).withOpacity(0.2),
                      child: Icon(scheme['icon'], size: 40, color: scheme['color']),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme['color'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        scheme['benefit'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(scheme['icon'], color: scheme['color'], size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            scheme['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        scheme['description'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: (scheme['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: scheme['color'],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSchemeDetails(Map<String, dynamic> scheme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header with icon and title
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (scheme['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(scheme['icon'], color: scheme['color'], size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme['color'],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              scheme['benefit'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    scheme['image'],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: (scheme['color'] as Color).withOpacity(0.2),
                      child: Icon(scheme['icon'], size: 60, color: scheme['color']),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  scheme['description'],
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                ),

                const SizedBox(height: 20),

                // Eligibility
                const Text(
                  'Eligibility',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          scheme['eligibility'],
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Details
                const Text(
                  'Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  scheme['details'],
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                ),

                const SizedBox(height: 24),

                // Apply Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Application process for ${scheme['name']}'),
                          backgroundColor: scheme['color'],
                        ),
                      );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Apply Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
