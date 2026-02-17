import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../widgets/status_timeline.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/custom_button.dart';
import '../../core/constants.dart';
import '../../theme/app_theme.dart';

class UpdateOrderStatusScreen extends StatefulWidget {
  final String orderId;

  const UpdateOrderStatusScreen({super.key, required this.orderId});

  @override
  State<UpdateOrderStatusScreen> createState() =>
      _UpdateOrderStatusScreenState();
}

class _UpdateOrderStatusScreenState extends State<UpdateOrderStatusScreen> {
  String? _selectedStatus;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updateStatus() async {
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a status'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final success = await orderProvider.updateOrderStatus(
      orderId: widget.orderId,
      status: _selectedStatus!,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order status updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _notesController.clear();
      setState(() {
        _selectedStatus = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(orderProvider.errorMessage ?? 'Failed to update status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Order Status'),
      ),
      body: StreamBuilder<OrderModel?>(
        stream: orderProvider.streamOrder(widget.orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget(message: 'Loading order details...');
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final order = snapshot.data;
          if (order == null) {
            return const Center(
              child: Text('Order not found'),
            );
          }

          // Initialize selected status if not set
          _selectedStatus ??= order.status;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order Header Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Order #${order.orderId.substring(0, 8)}',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              _buildStatusChip(context, order.status),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(
                            context,
                            'Customer',
                            order.customerName,
                            Icons.person_outlined,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Order Date',
                            DateFormat('MMM dd, yyyy • hh:mm a')
                                .format(order.timestamp),
                            Icons.calendar_today_outlined,
                          ),
                          const Divider(height: 24),
                          _buildInfoRow(
                            context,
                            'Delivery Address',
                            order.deliveryAddress ?? 'N/A',
                            Icons.location_on_outlined,
                          ),
                          if (order.phoneNumber != null) ...[
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              'Phone',
                              order.phoneNumber!,
                              Icons.phone_outlined,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Order Items
                  Text(
                    'Order Items',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ...order.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${item.quantity} ${item.unit} × \$${item.price.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '\$${item.total.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.primaryGreen,
                                          ),
                                    ),
                                  ],
                                ),
                              )),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Amount',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                '\$${order.totalAmount.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryGreen,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current Status Timeline
                  Text(
                    'Order Tracking',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StatusTimeline(
                        currentStatus: order.status,
                        allStatuses: AppConstants.orderStatuses,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Update Status Section
                  if (order.status != AppConstants.statusDelivered) ...[
                    Text(
                      'Update Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select New Status',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: AppConstants.orderStatuses.map((status) {
                                final isSelected = _selectedStatus == status;
                                final color = AppTheme.getStatusColor(status);
                                return ChoiceChip(
                                  label: Text(status),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedStatus = status;
                                      });
                                    }
                                  },
                                  selectedColor: color.withValues(alpha: 0.2),
                                  labelStyle: TextStyle(
                                    color: isSelected ? color : null,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? color
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Notes (Optional)',
                                hintText: 'Add any additional notes...',
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            Consumer<OrderProvider>(
                              builder: (context, provider, child) {
                                return CustomButton(
                                  text: 'Update Status',
                                  onPressed: _updateStatus,
                                  isLoading: provider.isLoading,
                                  icon: Icons.update,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      color: Colors.green.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 48,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Completed',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'This order has been delivered',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final color = AppTheme.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
