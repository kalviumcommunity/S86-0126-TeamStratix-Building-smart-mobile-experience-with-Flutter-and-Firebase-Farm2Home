import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/payment_provider.dart';
import '../../providers/auth_provider.dart';

class PaymentScreen extends StatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cash_on_delivery';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cash_on_delivery',
      'name': 'Cash on Delivery',
      'icon': Icons.money,
      'description': 'Pay when you receive your order',
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'description': 'Pay securely with your card',
    },
    {
      'id': 'upi',
      'name': 'UPI',
      'icon': Icons.qr_code,
      'description': 'Pay using UPI apps',
    },
  ];

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    if (authProvider.currentUser == null) {
      setState(() => _isProcessing = false);
      return;
    }

    try {
      // Create payment record
      final payment = await paymentProvider.createPayment(
        orderId: widget.orderId,
        customerId: authProvider.currentUser!.uid,
        amount: widget.amount,
        paymentMethod: _selectedPaymentMethod,
      );

      if (payment == null) {
        throw Exception('Failed to create payment');
      }

      // Process payment
      final result = await paymentProvider.processPayment(
        paymentId: payment.paymentId,
        paymentMethod: _selectedPaymentMethod,
        amount: widget.amount,
      );

      setState(() => _isProcessing = false);

      if (mounted) {
        if (result['success']) {
          _showSuccessDialog(result['message']);
        } else {
          _showErrorDialog(result['message']);
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Payment Successful'),
          ],
        ),
        content: Text(message.isEmpty ? 'Your payment has been processed successfully' : message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Text('Payment Failed'),
          ],
        ),
        content: Text(message.isEmpty ? 'Payment processing failed. Please try again.' : message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Payment Method'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Amount card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${widget.amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Payment methods
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final isSelected = _selectedPaymentMethod == method['id'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor:
                          isSelected ? Colors.green : Colors.grey[300],
                      child: Icon(
                        method['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                    title: Text(
                      method['name'] as String,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(method['description'] as String),
                    trailing: Radio<String>(
                      value: method['id'] as String,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() => _selectedPaymentMethod = value!);
                      },
                      activeColor: Colors.green,
                    ),
                    onTap: () {
                      setState(() => _selectedPaymentMethod = method['id'] as String);
                    },
                  ),
                );
              },
            ),
          ),

          // Pay button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Pay ₹${widget.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
