import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore Queries Demo Screen
/// Demonstrates where(), orderBy(), and limit() query operations
class FirestoreQueriesDemoScreen extends StatefulWidget {
  const FirestoreQueriesDemoScreen({super.key});

  @override
  State<FirestoreQueriesDemoScreen> createState() =>
      _FirestoreQueriesDemoScreenState();
}

class _FirestoreQueriesDemoScreenState extends State<FirestoreQueriesDemoScreen> {
  String _selectedQueryType = 'all';
  int _selectedLimit = 10;
  String _sortOrder = 'descending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Queries Demo'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Query Type Selector
            _buildQuerySelector(),
            const SizedBox(height: 16),

            // Limit Selector
            _buildLimitSelector(),
            const SizedBox(height: 16),

            // Sort Order Selector
            _buildSortOrderSelector(),
            const SizedBox(height: 24),

            // Query Info Card
            _buildQueryInfoCard(),
            const SizedBox(height: 16),

            // Query Results
            _buildQueryResults(),
          ],
        ),
      ),
    );
  }

  /// Build query type selector
  Widget _buildQuerySelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Query Type (where clause)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQueryButton('all', 'All Orders'),
                _buildQueryButton('pending', 'Status: Pending'),
                _buildQueryButton('completed', 'Status: Completed'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual query button
  Widget _buildQueryButton(String type, String label) {
    final isSelected = _selectedQueryType == type;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedQueryType = type),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  /// Build limit selector
  Widget _buildLimitSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Limit Results',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Slider(
              value: _selectedLimit.toDouble(),
              min: 1,
              max: 50,
              divisions: 49,
              label: '$_selectedLimit items',
              onChanged: (value) =>
                  setState(() => _selectedLimit = value.toInt()),
            ),
            Text('Current limit: $_selectedLimit documents'),
          ],
        ),
      ),
    );
  }

  /// Build sort order selector
  Widget _buildSortOrderSelector() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order By (createdAt)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Newest First'),
                    value: 'descending',
                    groupValue: _sortOrder,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortOrder = value);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Oldest First'),
                    value: 'ascending',
                    groupValue: _sortOrder,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _sortOrder = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build query info card
  Widget _buildQueryInfoCard() {
    return Card(
      elevation: 3,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Query:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            _buildQueryCodeBlock(),
          ],
        ),
      ),
    );
  }

  /// Build query code block
  Widget _buildQueryCodeBlock() {
    String whereClause = '';
    if (_selectedQueryType == 'pending') {
      whereClause = ".where('status', isEqualTo: 'pending')\n";
    } else if (_selectedQueryType == 'completed') {
      whereClause = ".where('status', isEqualTo: 'completed')\n";
    }

    String orderClause =
        ".orderBy('createdAt', descending: ${_sortOrder == 'descending'})\n";
    String limitClause = ".limit($_selectedLimit)";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          "FirebaseFirestore.instance\n"
          "  .collection('orders')\n"
          "$whereClause"
          "$orderClause"
          "$limitClause",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  /// Build query results
  Widget _buildQueryResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Query Results:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _buildQuery(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No results found'),
              );
            }

            final docs = snapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data();
                return _buildOrderCard(doc.id, data);
              },
            );
          },
        ),
      ],
    );
  }

  /// Build individual order card
  Widget _buildOrderCard(String docId, Map<String, dynamic> data) {
    final status = data['status'] ?? 'unknown';
    final createdAt = data['createdAt'] as Timestamp?;
    final formattedDate = createdAt != null
        ? createdAt.toDate().toString().split('.')[0]
        : 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: $docId',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: $status',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(status),
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(height: 4),
                      Text('Created: $formattedDate',
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build status badge
  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case 'completed':
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Get color for status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  /// Build Firestore query based on selections
  Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery() {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('orders');

    // Apply where filter
    if (_selectedQueryType == 'pending') {
      query = query.where('status', isEqualTo: 'pending');
    } else if (_selectedQueryType == 'completed') {
      query = query.where('status', isEqualTo: 'completed');
    }

    // Apply orderBy
    query = query.orderBy('createdAt',
        descending: _sortOrder == 'descending');

    // Apply limit
    query = query.limit(_selectedLimit);

    return query.snapshots();
  }
}
