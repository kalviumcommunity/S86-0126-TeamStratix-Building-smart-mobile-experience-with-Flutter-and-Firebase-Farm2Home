import 'package:flutter/material.dart';

/// Responsive Layout Screen demonstrating Container, Row, and Column widgets
class ResponsiveLayoutScreen extends StatelessWidget {
  const ResponsiveLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Responsive Layout Demo'),
        backgroundColor: const Color(0xFF4A7C4A),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Section - Full width container
              _buildHeaderSection(screenWidth),
              const SizedBox(height: 16),

              // Info Cards Section - Responsive layout
              _buildInfoSection(isLargeScreen),
              const SizedBox(height: 16),

              // Feature Grid - Adapts to screen size
              _buildFeatureGrid(isLargeScreen),
              const SizedBox(height: 16),

              // Statistics Section - Row layout
              _buildStatisticsSection(),
              const SizedBox(height: 16),

              // Action Buttons - Responsive spacing
              _buildActionButtons(isLargeScreen),
              const SizedBox(height: 16),

              // Footer Information
              _buildFooter(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  /// Header section with gradient container
  Widget _buildHeaderSection(double screenWidth) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A7C4A), Color(0xFF2D5A2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.agriculture,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'Farm2Home',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Screen Width: ${screenWidth.toStringAsFixed(0)}px',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  /// Info section with side-by-side panels on large screens
  Widget _buildInfoSection(bool isLargeScreen) {
    if (isLargeScreen) {
      // Side-by-side layout for large screens
      return Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              'Fresh Products',
              'Organic vegetables and fruits directly from local farms',
              Colors.amber,
              Icons.local_florist,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildInfoCard(
              'Fast Delivery',
              'Same-day delivery for orders placed before noon',
              Colors.greenAccent,
              Icons.delivery_dining,
            ),
          ),
        ],
      );
    } else {
      // Stacked layout for small screens
      return Column(
        children: [
          _buildInfoCard(
            'Fresh Products',
            'Organic vegetables and fruits directly from local farms',
            Colors.amber,
            Icons.local_florist,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Fast Delivery',
            'Same-day delivery for orders placed before noon',
            Colors.greenAccent,
            Icons.delivery_dining,
          ),
        ],
      );
    }
  }

  /// Individual info card widget
  Widget _buildInfoCard(String title, String description, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color.withValues(alpha: 0.8)),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Feature grid that adjusts columns based on screen size
  Widget _buildFeatureGrid(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          isLargeScreen
              ? Row(
                  children: [
                    Expanded(child: _buildFeatureItem(Icons.security, 'Secure')),
                    Expanded(child: _buildFeatureItem(Icons.support_agent, 'Support')),
                    Expanded(child: _buildFeatureItem(Icons.verified, 'Verified')),
                    Expanded(child: _buildFeatureItem(Icons.eco, 'Eco-Friendly')),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildFeatureItem(Icons.security, 'Secure')),
                        Expanded(child: _buildFeatureItem(Icons.support_agent, 'Support')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildFeatureItem(Icons.verified, 'Verified')),
                        Expanded(child: _buildFeatureItem(Icons.eco, 'Eco-Friendly')),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  /// Individual feature item
  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 40, color: const Color(0xFF4A7C4A)),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Statistics section with Row layout
  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A7C4A).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('500+', 'Products'),
          _buildStatDivider(),
          _buildStatItem('10K+', 'Customers'),
          _buildStatDivider(),
          _buildStatItem('50+', 'Farms'),
        ],
      ),
    );
  }

  /// Individual statistic item
  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A7C4A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  /// Divider between statistics
  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.black26,
    );
  }

  /// Action buttons with responsive layout
  Widget _buildActionButtons(bool isLargeScreen) {
    if (isLargeScreen) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Start Shopping'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A7C4A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.info),
              label: const Text('Learn More'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF4A7C4A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Color(0xFF4A7C4A), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Start Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A7C4A),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.info),
            label: const Text('Learn More'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4A7C4A),
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF4A7C4A), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      );
    }
  }

  /// Footer section
  Widget _buildFooter(double screenWidth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D5A2D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Farm2Home - Fresh from Farm to Your Door',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.facebook, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.email, color: Colors.white),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
