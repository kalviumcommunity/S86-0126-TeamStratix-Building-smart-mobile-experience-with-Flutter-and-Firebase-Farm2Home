import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/farm_diary_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/farmer_services_hub.dart';
import '../../widgets/loading_widget.dart';

class FarmLogScreen extends StatefulWidget {
  const FarmLogScreen({super.key});

  @override
  State<FarmLogScreen> createState() => _FarmLogScreenState();
}

class _FarmLogScreenState extends State<FarmLogScreen> with SingleTickerProviderStateMixin {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();
  late TabController _tabController;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _detailsController = TextEditingController();

  String _selectedActivityType = 'activity';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final farmerId = authProvider.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Log'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All'),
            Tab(icon: Icon(Icons.trending_up), text: 'Income'),
            Tab(icon: Icon(Icons.trending_down), text: 'Expense'),
            Tab(icon: Icon(Icons.medical_services), text: 'Fertilizer'),
            Tab(icon: Icon(Icons.local_dining), text: 'Harvest'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Quick Stats
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: FutureBuilder<Map<String, double>>(
              future: _servicesHub.getFarmStats(farmerId),
              builder: (context, snapshot) {
                final stats = snapshot.data ?? {};
                return Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '₹${stats['totalIncome']?.toStringAsFixed(0) ?? '0'}',
                        'Total Income',
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '₹${stats['totalExpense']?.toStringAsFixed(0) ?? '0'}',
                        'Total Expense',
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '₹${stats['profit']?.toStringAsFixed(0) ?? '0'}',
                        'Profit/Loss',
                        Colors.blue,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEntriesList(farmerId, ''),
                _buildEntriesList(farmerId, 'income'),
                _buildEntriesList(farmerId, 'expense'),
                _buildEntriesList(farmerId, 'fertilizer'),
                _buildEntriesList(farmerId, 'harvest'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildEntriesList(String farmerId, String typeFilter) {
    return StreamBuilder<List<FarmDiaryEntry>>(
      stream: _servicesHub.getFarmerDiaryEntries(farmerId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingWidget();
        }

        var entries = snapshot.data ?? [];
        if (typeFilter.isNotEmpty) {
          entries = entries.where((e) => e.activityType == typeFilter).toList();
        }

        if (entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No entries yet', style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            return _buildEntryCard(entry);
          },
        );
      },
    );
  }

  Widget _buildEntryCard(FarmDiaryEntry entry) {
    final color = _getTypeColor(entry.activityType);
    final icon = _getTypeIcon(entry.activityType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.description, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (entry.cropName != null) Text(entry.cropName!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            if (entry.amount != null)
              Text(
                '₹${entry.amount!.toStringAsFixed(0)}',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'income':
        return Colors.green;
      case 'expense':
        return Colors.red;
      case 'fertilizer':
        return Colors.blue;
      case 'harvest':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'income':
        return Icons.trending_up;
      case 'expense':
        return Icons.trending_down;
      case 'fertilizer':
        return Icons.medical_services;
      case 'harvest':
        return Icons.local_dining;
      default:
        return Icons.list;
    }
  }

  void _showAddEntryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Farm Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedActivityType,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'activity', child: Text('Activity')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'fertilizer', child: Text('Fertilizer')),
                  DropdownMenuItem(value: 'harvest', child: Text('Harvest')),
                ],
                onChanged: (value) => setState(() => _selectedActivityType = value!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              if (_selectedActivityType != 'activity')
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => _addEntry(), child: const Text('Add')),
        ],
      ),
    );
  }

  void _addEntry() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final entry = FarmDiaryEntry(
      entryId: '',
      farmerId: authProvider.currentUser!.uid,
      activityType: _selectedActivityType,
      description: _descriptionController.text,
      amount: _selectedActivityType != 'activity' ? double.tryParse(_amountController.text) : null,
      date: DateTime.now(),
      createdAt: DateTime.now(),
    );

    await _servicesHub.addDiaryEntry(entry);
    if (mounted) {
      _descriptionController.clear();
      _amountController.clear();
      Navigator.pop(context);
    }
  }
}
