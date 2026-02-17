import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../core/constants.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  
  UserModel? _selectedFarmer;
  final List<OrderItem> _items = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).loadFarmers();
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _addItem() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(
        onAdd: (item) {
          setState(() {
            _items.add(item);
          });
        },
      ),
    );
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedFarmer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a farmer'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final user = authProvider.currentUser!;

    final order = OrderModel(
      orderId: '',
      customerId: user.uid,
      customerName: user.name,
      farmerId: _selectedFarmer!.uid,
      farmerName: _selectedFarmer!.name,
      items: _items,
      status: AppConstants.statusReceived,
      timestamp: DateTime.now(),
      deliveryAddress: _addressController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
    );

    final success = await orderProvider.createOrder(order);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(orderProvider.errorMessage ?? 'Failed to place order'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading && orderProvider.farmers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Select Farmer
                    Text(
                      'Select Farmer',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DropdownButtonFormField<UserModel>(
                          initialValue: _selectedFarmer,
                          decoration: const InputDecoration(
                            labelText: 'Farmer',
                            prefixIcon: Icon(Icons.agriculture_outlined),
                            border: InputBorder.none,
                          ),
                          items: orderProvider.farmers.map((farmer) {
                            return DropdownMenuItem(
                              value: farmer,
                              child: Text(farmer.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFarmer = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a farmer';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Delivery Details
                    Text(
                      'Delivery Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _addressController,
                              label: 'Delivery Address',
                              hint: 'Enter your delivery address',
                              prefixIcon: Icons.location_on_outlined,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter delivery address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (value.length < 10) {
                                  return 'Please enter valid phone number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Order Items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Items',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        IconButton(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add_circle),
                          iconSize: 32,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (_items.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.shopping_basket_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items added',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: _addItem,
                                  child: const Text('Add Item'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ..._items.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.shopping_basket),
                            ),
                            title: Text(item.name),
                            subtitle: Text(
                              '${item.quantity} ${item.unit} × \$${item.price.toStringAsFixed(2)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: Colors.red,
                                  onPressed: () => _removeItem(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                    if (_items.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Card(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
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
                                '\$${_items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 32),

                    // Place Order Button
                    CustomButton(
                      text: 'Place Order',
                      onPressed: _placeOrder,
                      isLoading: orderProvider.isLoading,
                      icon: Icons.check,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AddItemDialog extends StatefulWidget {
  final Function(OrderItem) onAdd;

  const _AddItemDialog({required this.onAdd});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  String _selectedUnit = 'kg';

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_formKey.currentState!.validate()) {
      final item = OrderItem(
        name: _nameController.text.trim(),
        quantity: double.parse(_quantityController.text),
        unit: _selectedUnit,
        price: double.parse(_priceController.text),
      );
      widget.onAdd(item);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Item Name',
                hint: 'e.g., Tomatoes',
                prefixIcon: Icons.shopping_basket_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      controller: _quantityController,
                      label: 'Quantity',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                      ),
                      items: ['kg', 'g', 'lb', 'pcs', 'dozen']
                          .map((unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedUnit = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                label: 'Price per Unit (\$)',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid price';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addItem,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
