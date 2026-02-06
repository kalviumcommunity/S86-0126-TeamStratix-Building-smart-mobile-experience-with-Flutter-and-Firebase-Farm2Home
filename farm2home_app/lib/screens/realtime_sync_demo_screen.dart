import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

/// Real-Time Sync Demo Screen
/// Demonstrates Firestore snapshot listeners for instant data synchronization
/// 
/// Features:
/// - Collection snapshots (live product updates)
/// - Document snapshots (live user profile)
/// - Change detection (added/modified/removed)
/// - Manual listeners with custom logic
/// - Empty and loading state handling
class RealtimeSyncDemoScreen extends StatefulWidget {
  const RealtimeSyncDemoScreen({super.key});

  @override
  State<RealtimeSyncDemoScreen> createState() => _RealtimeSyncDemoScreenState();
}

class _RealtimeSyncDemoScreenState extends State<RealtimeSyncDemoScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final List<String> _changeLog = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupManualListener();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Manual listener setup for change detection
  void _setupManualListener() {
    FirebaseFirestore.instance
        .collection('products')
        .limit(5)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        final productName = change.doc.data()?['name'] ?? 'Unknown';
        final changeTime = DateTime.now().toLocal().toString().substring(11, 19);
        
        setState(() {
          switch (change.type) {
            case DocumentChangeType.added:
              _changeLog.insert(
                0,
                '[$changeTime] ✅ NEW: "$productName" added',
              );
              break;
            case DocumentChangeType.modified:
              _changeLog.insert(
                0,
                '[$changeTime] 📝 UPDATED: "$productName" modified',
              );
              break;
            case DocumentChangeType.removed:
              _changeLog.insert(
                0,
                '[$changeTime] ❌ DELETED: "$productName" removed',
              );
              break;
          }
        });

        // Keep only last 20 changes
        if (_changeLog.length > 20) {
          _changeLog.removeLast();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4EDD4),
      appBar: AppBar(
        title: const Text('Real-Time Sync Demo'),
        backgroundColor: const Color(0xFF4A7C4A),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Collection'),
            Tab(icon: Icon(Icons.person), text: 'Document'),
            Tab(icon: Icon(Icons.notifications), text: 'Changes'),
            Tab(icon: Icon(Icons.info), text: 'Info'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCollectionListenerTab(),
          _buildDocumentListenerTab(),
          _buildChangeLogTab(),
          _buildInfoTab(),
        ],
      ),
    );
  }

  /// Tab 1: Collection Snapshot Listener
  /// Shows real-time list of all products
  Widget _buildCollectionListenerTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue[50],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📦 Collection Snapshot Listener',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Listens to ALL products collection. Updates instantly when ANY product is added, updated, or deleted.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                .limit(20)
                .snapshots(),
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF4A7C4A)),
                      SizedBox(height: 16),
                      Text('Connecting to Firestore...'),
                    ],
                  ),
                );
              }

              // Error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // Empty state
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No products available',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add a product from Firestore Console\nto see real-time updates!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                );
              }

              // Data state - display products
              final products = snapshot.data!.docs;

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.green[50],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.circle, size: 12, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '🔴 LIVE: ${products.length} products synced',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final data = products[index].data();

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFD4EDD4),
                              child: Text(
                                data['imageIcon'] ?? '📦',
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            title: Text(
                              data['name'] ?? 'Unknown',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '\$${data['price']?.toStringAsFixed(2) ?? '0.00'} / ${data['unit'] ?? 'unit'}',
                                  style: const TextStyle(
                                    color: Color(0xFF4A7C4A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      data['isAvailable'] == true
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      size: 14,
                                      color: data['isAvailable'] == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      data['isAvailable'] == true
                                          ? 'Available'
                                          : 'Unavailable',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Chip(
                              label: Text(
                                'Stock: ${data['stockQuantity'] ?? 0}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              backgroundColor: Colors.blue[50],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Tab 2: Document Snapshot Listener
  /// Shows real-time user profile data
  Widget _buildDocumentListenerTab() {
    final user = _authService.currentUser;

    if (user == null) {
      return const Center(
        child: Text('Please log in to see document listener demo'),
      );
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.purple[50],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '👤 Document Snapshot Listener',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Listens to a SINGLE user document. Updates instantly when any field changes.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF4A7C4A)),
                      SizedBox(height: 16),
                      Text('Loading user profile...'),
                    ],
                  ),
                );
              }

              // Error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                    ],
                  ),
                );
              }

              // Document doesn't exist
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'User profile not found',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Update your profile in Firestore Console\nto see real-time changes!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                );
              }

              // Data state
              final data = snapshot.data!.data()!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 12, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            '🔴 LIVE: Profile synced in real-time',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: const Color(0xFF4A7C4A),
                      child: Text(
                        data['name']?.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildProfileRow(
                              Icons.person,
                              'Name',
                              data['name'] ?? 'Not set',
                            ),
                            const Divider(),
                            _buildProfileRow(
                              Icons.email,
                              'Email',
                              data['email'] ?? user.email ?? 'Not set',
                            ),
                            const Divider(),
                            _buildProfileRow(
                              Icons.phone,
                              'Phone',
                              data['phone'] ?? 'Not set',
                            ),
                            const Divider(),
                            _buildProfileRow(
                              Icons.badge,
                              'Role',
                              data['role'] ?? 'customer',
                            ),
                            const Divider(),
                            _buildProfileRow(
                              Icons.access_time,
                              'Last Updated',
                              _formatTimestamp(data['updatedAt']),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Try This:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. Open Firebase Console\n'
                            '2. Navigate to users collection\n'
                            '3. Edit your profile (name, phone, etc.)\n'
                            '4. Watch this screen update INSTANTLY!',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A7C4A)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Tab 3: Change Log (Manual Listener)
  /// Shows detected changes with types
  Widget _buildChangeLogTab() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.orange[50],
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🔔 Change Detection Log',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Manual listener tracking DocumentChangeType: ADDED, MODIFIED, REMOVED',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        Expanded(
          child: _changeLog.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No changes detected yet',
                        style: TextStyle(fontSize: 18, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add, update, or delete products\nfrom Firestore Console',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _changeLog.length,
                  itemBuilder: (context, index) {
                    final log = _changeLog[index];
                    Color? color;
                    IconData icon;

                    if (log.contains('NEW:')) {
                      color = Colors.green[50];
                      icon = Icons.add_circle;
                    } else if (log.contains('UPDATED:')) {
                      color = Colors.blue[50];
                      icon = Icons.edit;
                    } else {
                      color = Colors.red[50];
                      icon = Icons.delete;
                    }

                    return Card(
                      color: color,
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(icon),
                        title: Text(
                          log,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Tab 4: Info & Code Examples
  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📚 Real-Time Sync Documentation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            '📦 Collection Snapshots',
            'Listen to ALL documents in a collection',
            '''
FirebaseFirestore.instance
  .collection('products')
  .snapshots()
  .listen((snapshot) {
    // Updates when ANY product changes
  });
''',
            Colors.blue,
          ),
          _buildInfoCard(
            '👤 Document Snapshots',
            'Listen to a SINGLE document',
            '''
FirebaseFirestore.instance
  .collection('users')
  .doc(userId)
  .snapshots()
  .listen((snapshot) {
    // Updates when THIS user changes
  });
''',
            Colors.purple,
          ),
          _buildInfoCard(
            '🔔 Change Detection',
            'Track what changed (added/modified/removed)',
            '''
.snapshots().listen((snapshot) {
  for (var change in snapshot.docChanges) {
    switch (change.type) {
      case DocumentChangeType.added:
        print('Added: \${change.doc.id}');
      case DocumentChangeType.modified:
        print('Updated: \${change.doc.id}');
      case DocumentChangeType.removed:
        print('Deleted: \${change.doc.id}');
    }
  }
});
''',
            Colors.orange,
          ),
          _buildInfoCard(
            '🎨 StreamBuilder Pattern',
            'Automatically rebuilds UI when data changes',
            '''
StreamBuilder<QuerySnapshot>(
  stream: collection.snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == 
        ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (!snapshot.hasData) {
      return Text('No data');
    }
    
    return ListView(
      children: snapshot.data!.docs
        .map((doc) => ListTile(...))
        .toList(),
    );
  },
)
''',
            Colors.green,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber),
                    SizedBox(width: 8),
                    Text(
                      'Why Real-Time Sync Matters',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  '✅ Instant updates across all devices\n'
                  '✅ No manual refresh needed\n'
                  '✅ Modern, responsive UX\n'
                  '✅ Perfect for chat, notifications, live data\n'
                  '✅ Automatic conflict resolution\n'
                  '✅ Works offline with sync when online',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String description,
    String code,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  color: color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                code,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Never';
    
    try {
      if (timestamp is Timestamp) {
        final date = timestamp.toDate();
        return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      }
      return 'Invalid timestamp';
    } catch (e) {
      return 'Error parsing time';
    }
  }
}
