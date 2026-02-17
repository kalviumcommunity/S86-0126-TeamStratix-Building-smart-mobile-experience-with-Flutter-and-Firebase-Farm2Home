import 'package:flutter/material.dart';
import '../../models/community_model.dart';
import '../../services/farmer_services_hub.dart';
import '../../widgets/loading_widget.dart';

class FarmCommunityScreen extends StatefulWidget {
  const FarmCommunityScreen({super.key});

  @override
  State<FarmCommunityScreen> createState() => _FarmCommunityScreenState();
}

class _FarmCommunityScreenState extends State<FarmCommunityScreen> {
  final FarmerServicesHub _servicesHub = FarmerServicesHub();
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers Hub'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Discussion', 'Advice', 'Tips', 'Question'].map((cat) {
                  bool isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (sel) => setState(() => _selectedCategory = cat),
                      backgroundColor: Colors.white,
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Posts List
          Expanded(
            child: StreamBuilder<List<CommunityPost>>(
              stream: _servicesHub.getCommunityPosts(
                category: _selectedCategory == 'All' ? null : _selectedCategory.toLowerCase(),
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                }

                final posts = snapshot.data ?? [];

                if (posts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 12),
                        Text('No posts yet', style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) => _buildPostCard(posts[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Share'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Info
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade200,
                  child: Text(post.farmerName[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.farmerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(_getCategoryLabel(post.category), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(post.category).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.category,
                    style: TextStyle(fontSize: 10, color: _getCategoryColor(post.category), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Post Title & Content
            Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text(post.content, maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, height: 1.4)),

            const SizedBox(height: 12),

            // Tags
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 6,
                children: post.tags.map((tag) {
                  return Chip(
                    label: Text('#$tag', style: const TextStyle(fontSize: 10)),
                    backgroundColor: Colors.blue.shade100,
                    labelStyle: const TextStyle(color: Colors.blue),
                  );
                }).toList(),
              ),

            const SizedBox(height: 12),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAction('👍', '${post.likes}', () {}),
                _buildAction('💬', '${post.commentCount}', () {}),
                _buildAction('📤', 'Share', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'discussion':
        return Colors.blue;
      case 'advice':
        return Colors.green;
      case 'tips':
        return Colors.orange;
      case 'question':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'discussion':
        return 'Discussion';
      case 'advice':
        return 'Expert Advice';
      case 'tips':
        return 'Farming Tips';
      case 'question':
        return 'Question';
      default:
        return category;
    }
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share with Farmers Hub'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Title', border: OutlineInputBorder())),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'What\'s on your mind?', border: OutlineInputBorder()),
                maxLines: 4,
              ),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Tags (comma separated)', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Post')),
        ],
      ),
    );
  }
}
