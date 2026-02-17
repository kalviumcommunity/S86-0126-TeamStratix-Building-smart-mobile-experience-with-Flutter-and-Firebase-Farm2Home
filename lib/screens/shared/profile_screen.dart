import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _nameController.text = authProvider.currentUser?.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.updateProfile(_nameController.text.trim());

    if (!mounted) return;

    if (success) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Update failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleSignOut() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;
          if (user == null) {
            return const Center(child: Text('No user data'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Profile Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      user.isCustomer
                          ? Icons.person
                          : Icons.agriculture,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Info Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (_isEditing) ...[
                            CustomTextField(
                              controller: _nameController,
                              label: 'Name',
                              prefixIcon: Icons.person_outlined,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: 'Cancel',
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = false;
                                        _nameController.text = user.name;
                                      });
                                    },
                                    isOutlined: true,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomButton(
                                    text: 'Save',
                                    onPressed: _handleUpdate,
                                    isLoading: authProvider.isLoading,
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            _buildInfoRow(
                              context,
                              'Name',
                              user.name,
                              Icons.person_outlined,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              'Email',
                              user.email,
                              Icons.email_outlined,
                            ),
                            const Divider(height: 24),
                            _buildInfoRow(
                              context,
                              'Role',
                              user.role.toUpperCase(),
                              user.isCustomer
                                  ? Icons.shopping_basket_outlined
                                  : Icons.agriculture_outlined,
                            ),
                            const SizedBox(height: 24),
                            CustomButton(
                              text: 'Edit Profile',
                              onPressed: () {
                                setState(() {
                                  _isEditing = true;
                                });
                              },
                              icon: Icons.edit,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign Out Button
                  CustomButton(
                    text: 'Sign Out',
                    onPressed: _handleSignOut,
                    icon: Icons.logout,
                    backgroundColor: Colors.red,
                  ),
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
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 16),
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
}
