import 'package:flutter/material.dart';
import '../../scripts/remove_duplicate_products.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';

/// Admin screen to clean up duplicate products
class CleanupProductsScreen extends StatefulWidget {
  const CleanupProductsScreen({super.key});

  @override
  State<CleanupProductsScreen> createState() => _CleanupProductsScreenState();
}

class _CleanupProductsScreenState extends State<CleanupProductsScreen> {
  bool _isLoading = false;
  String _message = '';
  Map<String, dynamic>? _result;

  Future<void> _runCleanupById() async {
    setState(() {
      _isLoading = true;
      _message = 'Scanning for duplicates by Product ID...';
      _result = null;
    });

    try {
      final result = await removeDuplicateProducts();
      setState(() {
        _isLoading = false;
        _result = result;
        _message = result['message'] as String;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_message),
            backgroundColor: result['success'] as bool
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _runCleanupByName() async {
    setState(() {
      _isLoading = true;
      _message = 'Scanning for duplicates by Product Name...';
      _result = null;
    });

    try {
      final result = await removeDuplicateProductsByName();
      setState(() {
        _isLoading = false;
        _result = result;
        _message = result['message'] as String;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_message),
            backgroundColor: result['success'] as bool
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _showStatistics() async {
    setState(() {
      _isLoading = true;
      _message = 'Loading statistics...';
    });

    try {
      await printProductStatistics();
      setState(() {
        _isLoading = false;
        _message = 'Check console for statistics';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Statistics printed to console/logs'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cleanup Products')),
      body: _isLoading
          ? const LoadingWidget(message: 'Processing...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const Icon(
                    Icons.cleaning_services,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Product Database Cleanup',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Remove duplicate products from Firestore',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),

                  // Info Card
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'About Cleanup',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• By Product ID: Removes products with duplicate document IDs\n'
                            '• By Product Name: Removes products with duplicate names (keeps newest)\n'
                            '• Statistics: View product counts by category and find duplicates',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cleanup Buttons
                  CustomButton(
                    text: 'Remove Duplicates by ID',
                    onPressed: _runCleanupById,
                    icon: Icons.delete_sweep,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Remove Duplicates by Name',
                    onPressed: _runCleanupByName,
                    icon: Icons.filter_1,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _showStatistics,
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('View Statistics'),
                  ),

                  const SizedBox(height: 32),

                  // Result Display
                  if (_result != null) ...[
                    Card(
                      color: (_result!['success'] as bool)
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  (_result!['success'] as bool)
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: (_result!['success'] as bool)
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Result',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _buildResultRow(
                              'Status',
                              _result!['message'] as String,
                            ),
                            _buildResultRow(
                              'Duplicates Removed',
                              (_result!['deletedCount'] as int).toString(),
                            ),
                            _buildResultRow(
                              'Unique Products',
                              (_result!['uniqueCount'] as int).toString(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (_message.isNotEmpty && _result == null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Warning
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.warning, color: Colors.orange),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Warning',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'This action cannot be undone. Make sure you have a backup before running cleanup operations.',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
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

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
