import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

/// Secure Profile Screen
/// Demonstrates Firebase Authentication + Firestore Security Rules
/// Users can only read/write their own profile document
class SecureProfileScreen extends StatefulWidget {
  const SecureProfileScreen({super.key});

  @override
  State<SecureProfileScreen> createState() => _SecureProfileScreenState();
}

class _SecureProfileScreenState extends State<SecureProfileScreen>
    with WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _phoneController;
  late TextEditingController _otherUserIDController;

  bool _isLoading = false;
  String? _successMessage;
  String? _errorMessage;
  Map<String, dynamic>? _userProfile;
  Map<String, dynamic>? _attemptedUnauthorizedRead;
  String? _unauthorizedAttemptError;
  bool _showAttemptedRead = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
    _otherUserIDController = TextEditingController();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _otherUserIDController.dispose();
    super.dispose();
  }

  /// Load current user's profile
  Future<void> _loadUserProfile() async {
    if (_authService.currentUserID == null) {
      setState(() {
        _errorMessage = 'No authenticated user';
      });
      return;
    }

    try {
      setState(() => _isLoading = true);
      final profile = await _authService.getUserProfile(_authService.currentUserID!);

      if (mounted) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile?['displayName'] ?? '';
          _bioController.text = profile?['bio'] ?? '';
          _phoneController.text = profile?['phone'] ?? '';
          _isLoading = false;
          _errorMessage = null;
          _successMessage = 'Profile loaded successfully (Allowed: Own document)';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load profile: ${e.toString()}';
        });
      }
    }
  }

  /// Update user's own profile (should succeed)
  Future<void> _updateOwnProfile() async {
    if (_authService.currentUserID == null) {
      setState(() => _errorMessage = 'No authenticated user');
      return;
    }

    try {
      setState(() => _isLoading = true);
      await _authService.updateUserProfile(
        uid: _authService.currentUserID!,
        displayName: _nameController.text,
        bio: _bioController.text,
        phone: _phoneController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _successMessage = 'Profile updated successfully (Allowed: Own document)';
          _errorMessage = null;
        });
        _loadUserProfile(); // Refresh profile
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to update profile: ${e.toString()}';
        });
      }
    }
  }

  /// Attempt to read another user's profile (should fail with Permission Denied)
  Future<void> _attemptUnauthorizedRead() async {
    if (_otherUserIDController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter another user\'s ID');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      final docSnapshot = await _firestore
          .collection('users')
          .doc(_otherUserIDController.text)
          .get();

      if (mounted) {
        setState(() {
          _isLoading = false;
          _attemptedUnauthorizedRead = docSnapshot.data();
          _showAttemptedRead = true;
          _unauthorizedAttemptError = null;
          _successMessage = 'Unexpected: Able to read other user\'s profile!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showAttemptedRead = true;
          _unauthorizedAttemptError = _extractFirebaseError(e.toString());
          _errorMessage = null;
          _successMessage = 'Firestore Rule Enforced: ${_unauthorizedAttemptError}';
        });
      }
    }
  }

  /// Attempt to write to another user's profile (should fail with Permission Denied)
  Future<void> _attemptUnauthorizedWrite() async {
    if (_otherUserIDController.text.isEmpty) {
      setState(() => _errorMessage = 'Please enter another user\'s ID');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _successMessage = null;
      });

      // Attempt to update another user's profile
      await _firestore.collection('users').doc(_otherUserIDController.text).update({
        'displayName': 'Hacked by ${_authService.currentUser?.email}',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        setState(() {
          _isLoading = false;
          _successMessage = 'Unexpected: Able to write to other user\'s profile!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _extractFirebaseError(e.toString());
          _successMessage = 'Firestore Rule Enforced: ${_errorMessage}';
        });
      }
    }
  }

  /// Extract Firebase error message
  String _extractFirebaseError(String error) {
    if (error.contains('PERMISSION_DENIED')) {
      return 'Permission Denied - Cannot access other user\'s document';
    } else if (error.contains('permission')) {
      return 'Permission Denied - Firestore rule blocked this action';
    } else if (error.contains('not found')) {
      return 'User not found or permission denied';
    }
    return 'Error: ${error.length > 100 ? error.substring(0, 100) : error}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Secure Profile'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: _isLoading && _userProfile == null
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.green.shade700,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Authentication Status Card
                  _buildAuthStatusCard(currentUser),
                  const SizedBox(height: 20),

                  // Messages
                  if (_successMessage != null) _buildSuccessMessage(),
                  if (_errorMessage != null) _buildErrorMessage(),
                  if (_successMessage != null || _errorMessage != null)
                    const SizedBox(height: 16),

                  // Your Profile Section (Allowed Read/Write)
                  _buildOwnProfileCard(),
                  const SizedBox(height: 20),

                  // Security Rules Explanation
                  _buildSecurityRulesCard(),
                  const SizedBox(height: 20),

                  // Unauthorized Access Test Section
                  _buildUnauthorizedAccessCard(),
                  const SizedBox(height: 20),

                  // Attempted Read Results
                  if (_showAttemptedRead) _buildAttemptedReadResultsCard(),
                ],
              ),
            ),
    );
  }

  /// Build authentication status card
  Widget _buildAuthStatusCard(User? user) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          border: Border.all(color: Colors.blue.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_user,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Authentication Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Authenticated: ${user?.email ?? 'No user'}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User ID (UID):',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    user?.uid ?? 'Not available',
                    style: const TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build own profile card (read/write allowed)
  Widget _buildOwnProfileCard() {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.green.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'ALLOWED: Read & Write your own document',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                label: const Text('Display Name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                label: const Text('Bio'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
              minLines: 2,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                label: const Text('Phone'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _updateOwnProfile,
                icon: const Icon(Icons.save),
                label: const Text('Update Your Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            if (_userProfile != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Data (From Firestore):',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildProfileDataView(_userProfile!),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build security rules explanation
  Widget _buildSecurityRulesCard() {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          border: Border.all(color: Colors.purple.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Firestore Security Rules',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'match /users/{uid} {',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.amber.shade300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'allow read, write:',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.blue.shade300,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            'if request.auth != null &&',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(
                            'request.auth.uid == uid;',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Colors.green.shade300,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Text(
                    '}',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.amber.shade300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rule Explanation:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRulePoint('✓ User must be authenticated (request.auth != null)'),
                  const SizedBox(height: 6),
                  _buildRulePoint('✓ User UID must match document ID (request.auth.uid == uid)'),
                  const SizedBox(height: 6),
                  _buildRulePoint('✗ Any other user attempting access is DENIED'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build rule explanation point
  Widget _buildRulePoint(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.black87,
      ),
    );
  }

  /// Build unauthorized access test section
  Widget _buildUnauthorizedAccessCard() {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.red.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.block,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Test Unauthorized Access',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'DENIED: Attempt to access another user\'s document',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otherUserIDController,
              decoration: InputDecoration(
                label: const Text('Other User\'s ID (UID)'),
                hintText: 'Paste another user\'s UID here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person_off),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _attemptUnauthorizedRead,
                    icon: const Icon(Icons.visibility_off),
                    label: const Text('Try Read'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _attemptUnauthorizedWrite,
                    icon: const Icon(Icons.edit_off),
                    label: const Text('Try Write'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to Test:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTestStep('1. Create at least 2 user accounts'),
                  const SizedBox(height: 6),
                  _buildTestStep('2. Sign in as the first user'),
                  const SizedBox(height: 6),
                  _buildTestStep('3. Copy the second user\'s UID'),
                  const SizedBox(height: 6),
                  _buildTestStep('4. Paste it above and click "Try Read" or "Try Write"'),
                  const SizedBox(height: 6),
                  _buildTestStep('5. Watch the Permission Denied error appear'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build test step text
  Widget _buildTestStep(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        color: Colors.black87,
      ),
    );
  }

  /// Build attempted read results
  Widget _buildAttemptedReadResultsCard() {
    final hasError = _unauthorizedAttemptError != null;

    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasError ? Colors.red.shade50 : Colors.green.shade50,
          border: Border.all(
            color: hasError ? Colors.red.shade300 : Colors.green.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: hasError ? Colors.red.shade700 : Colors.green.shade700,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasError ? Icons.error_outline : Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hasError
                        ? 'Access Attempt: BLOCKED'
                        : 'Access Attempt: Succeeded',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: hasError ? Colors.red.shade700 : Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (hasError)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Firestore Security Rule Enforced:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText(
                      _unauthorizedAttemptError ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
              )
            else if (_attemptedUnauthorizedRead != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'WARNING: Document was readable - this should not happen with proper security rules!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build profile data view
  Widget _buildProfileDataView(Map<String, dynamic> profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name: ${profile['displayName'] ?? 'Not set'}',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          'Email: ${profile['email'] ?? 'Not set'}',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          'Bio: ${profile['bio'] ?? 'Not set'}',
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 4),
        Text(
          'Phone: ${profile['phone'] ?? 'Not set'}',
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }

  /// Build success message widget
  Widget _buildSuccessMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        border: Border.all(color: Colors.green.shade500),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _successMessage ?? '',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build error message widget
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        border: Border.all(color: Colors.red.shade500),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage ?? '',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
