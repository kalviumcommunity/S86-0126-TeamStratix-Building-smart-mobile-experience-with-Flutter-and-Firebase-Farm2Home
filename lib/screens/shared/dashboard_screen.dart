import 'package:flutter/material.dart';
import '../../widgets/card_widgets.dart';
import '../../widgets/responsive_widgets.dart';
import '../../widgets/chart_widgets.dart';
import '../../core/app_breakpoints.dart';

class DashboardScreen extends StatelessWidget {
  final String userRole; // 'farmer' or 'admin'

  const DashboardScreen({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh dashboard data
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              
              // Stats Overview
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              
              _buildStatsGrid(context),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Charts Section
              Text(
                'Analytics',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              
              _buildChartsSection(context),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Recent Activity
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              
              _buildRecentActivity(context),
              
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: context.isMobile ? 2 : 4,
      childAspectRatio: context.isMobile ? 1.3 : 1.5,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        StatCard(
          title: userRole == 'farmer' ? 'Total Products' : 'Total Orders',
          value: '24',
          icon: userRole == 'farmer' 
              ? Icons.inventory_2_outlined 
              : Icons.shopping_cart_outlined,
          subtitle: '+2 this week',
        ),
        StatCard(
          title: userRole == 'farmer' ? 'Active Orders' : 'Active Farmers',
          value: '12',
          icon: userRole == 'farmer' 
              ? Icons.local_shipping_outlined 
              : Icons.people_outline,
          color: Colors.blue,
          subtitle: '3 pending',
        ),
        StatCard(
          title: 'Revenue',
          value: '\$2,450',
          icon: Icons.attach_money,
          color: Colors.green,
          subtitle: '+15% this month',
        ),
        StatCard(
          title: 'Completed',
          value: '89',
          icon: Icons.check_circle_outline,
          color: Colors.purple,
          subtitle: '92% success rate',
        ),
      ],
    );
  }

  Widget _buildChartsSection(BuildContext context) {
    return ResponsiveTwoColumn(
      leftChild: SimpleBarChart(
        title: 'Orders by Status',
        data: {
          'Received': 5,
          'Harvesting': 3,
          'Packed': 2,
          'Shipping': 4,
          'Delivered': 10,
        },
      ),
      rightChild: SimplePieChart(
        title: 'Product Categories',
        data: {
          'Vegetables': 12,
          'Fruits': 8,
          'Dairy': 6,
          'Grains': 4,
        },
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    final activities = [
      {
        'title': 'New order received',
        'subtitle': 'Order #1234 - \$45.00',
        'time': '5 min ago',
        'icon': Icons.shopping_bag,
        'color': Colors.blue,
      },
      {
        'title': 'Product harvested',
        'subtitle': 'Tomatoes - 50 lbs',
        'time': '1 hour ago',
        'icon': Icons.agriculture,
        'color': Colors.green,
      },
      {
        'title': 'Order delivered',
        'subtitle': 'Order #1230 completed',
        'time': '2 hours ago',
        'icon': Icons.check_circle,
        'color': Colors.purple,
      },
      {
        'title': 'Payment received',
        'subtitle': '\$120.00',
        'time': '3 hours ago',
        'icon': Icons.payment,
        'color': Colors.orange,
      },
    ];

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final activity = activities[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: (activity['color'] as Color).withOpacity(0.1),
              child: Icon(
                activity['icon'] as IconData,
                color: activity['color'] as Color,
              ),
            ),
            title: Text(activity['title'] as String),
            subtitle: Text(activity['subtitle'] as String),
            trailing: Text(
              activity['time'] as String,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        },
      ),
    );
  }
}
