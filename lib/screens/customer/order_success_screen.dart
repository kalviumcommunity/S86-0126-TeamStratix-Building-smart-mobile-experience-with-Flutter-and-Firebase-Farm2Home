import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  final double totalAmount;

  const OrderSuccessScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Animation or Icon
              Icon(Icons.check_circle, size: 120, color: Colors.green),
              const SizedBox(height: 32),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Thank you for your order!',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Order Details Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context,
                        'Order ID',
                        orderId.substring(0, 8).toUpperCase(),
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        'Total Amount',
                        '\$${totalAmount.toStringAsFixed(2)}',
                        valueColor: Theme.of(context).primaryColor,
                      ),
                      const Divider(height: 24),
                      _buildDetailRow(
                        context,
                        'Status',
                        'Order Received',
                        valueColor: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Info Text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You will receive updates about your order status',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Track Order Button
              CustomButton(
                text: 'Track Order',
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/customer-home', (route) => false);
                  // Navigate to orders tab
                  Navigator.of(
                    context,
                  ).pushNamed('/order-status', arguments: orderId);
                },
                icon: Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 12),

              // Continue Shopping Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/customer-home', (route) => false);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}
