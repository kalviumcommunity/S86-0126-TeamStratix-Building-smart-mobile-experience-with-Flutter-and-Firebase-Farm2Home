import 'package:flutter/material.dart';
import '../models/profile_form_data.dart';
import '../utils/form_validators.dart';

/// Profile Details Form Screen
/// Demonstrates complex form validation with multiple fields
/// Features:
/// - Full Name (required, min length)
/// - Email (email format)
/// - Phone Number (10 digits)
/// - Password (8+ chars with complexity)
/// - Confirm Password (must match)
class ProfileDetailsFormScreen extends StatefulWidget {
  const ProfileDetailsFormScreen({super.key});

  @override
  State<ProfileDetailsFormScreen> createState() =>
      _ProfileDetailsFormScreenState();
}

class _ProfileDetailsFormScreenState extends State<ProfileDetailsFormScreen> {
  /// Form key for validation
  /// Used to validate entire form at once
  late GlobalKey<FormState> _formKey;

  /// Text controllers for each form field
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  /// Track if form has been submitted (to show errors)
  bool _isSubmitted = false;

  /// Track if password is visible
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  /// Track form submission status
  bool _isLoading = false;

  /// Submitted data
  ProfileFormData? _submittedData;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    // Add listener to password field for confirm password validation
    _passwordController.addListener(() {
      setState(() {
        // Trigger rebuild to update confirm password validator
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validate entire form
  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  /// Handle form submission
  Future<void> _submitForm() async {
    setState(() => _isSubmitted = true);

    // Validate form using Form key
    if (!_validateForm()) {
      _showSnackBar('Please fix the errors above', isError: true);
      return;
    }

    // Show loading state
    setState(() => _isLoading = true);

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Create form data
      final formData = ProfileFormData(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      // Save data (In real app, send to backend)
      setState(() => _submittedData = formData);

      // Show success
      _showSnackBar('Profile saved successfully!', isError: false);
      _resetForm();
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Reset form to initial state
  void _resetForm() {
    _formKey.currentState?.reset();
    _fullNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _isSubmitted = false;
      _submittedData = null;
    });
  }

  /// Show snackbar message
  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details Form'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
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
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Enter Your Profile Details',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'All fields are required. Validation occurs in real-time as you type.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Form(
                key: _formKey,
                onChanged: () {
                  // Trigger rebuild to show real-time validation
                  if (_isSubmitted) {
                    setState(() {});
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                    _buildTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                      hint: 'John Doe',
                      icon: Icons.person,
                      validator: (value) =>
                          FormValidators.validateFullName(value),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    _buildTextField(
                      label: 'Email Address',
                      controller: _emailController,
                      hint: 'john@example.com',
                      icon: Icons.email,
                      validator: (value) =>
                          FormValidators.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Phone Number Field
                    _buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      hint: '1234567890',
                      icon: Icons.phone,
                      validator: (value) =>
                          FormValidators.validatePhoneNumber(value),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        // Allow numbers and format
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    _buildPasswordField(
                      label: 'Password',
                      controller: _passwordController,
                      hint: 'Enter strong password',
                      isVisible: _showPassword,
                      onVisibilityToggle: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                      validator: (value) =>
                          FormValidators.validatePassword(value),
                    ),
                    if (_passwordController.text.isNotEmpty)
                      _buildPasswordStrengthIndicator(
                        _passwordController.text,
                      ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      hint: 'Re-enter password',
                      isVisible: _showConfirmPassword,
                      onVisibilityToggle: () {
                        setState(
                            () => _showConfirmPassword = !_showConfirmPassword);
                      },
                      validator: (value) =>
                          FormValidators.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          disabledBackgroundColor: Colors.grey.shade300,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Submit Profile',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Reset Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _resetForm,
                        child: const Text('Reset Form'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Success Message
            if (_submittedData != null)
              _buildSuccessMessage(_submittedData!),
          ],
        ),
      ),
    );
  }

  /// Build text input field with validation
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    required TextInputType keyboardType,
    List<dynamic>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue.shade700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blue.shade700,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          validator: validator,
          onChanged: (_) {
            // Trigger validation as user types
            _formKey.currentState?.validate();
          },
        ),
      ],
    );
  }

  /// Build password input field
  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(Icons.lock, color: Colors.blue.shade700),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue.shade700,
              ),
              onPressed: onVisibilityToggle,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blue.shade700,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
          validator: validator,
          onChanged: (_) {
            // Trigger validation as user types
            _formKey.currentState?.validate();
          },
        ),
      ],
    );
  }

  /// Build password strength indicator
  Widget _buildPasswordStrengthIndicator(String password) {
    final strength = FormValidators.getPasswordStrength(password);
    final color = FormValidators.getPasswordStrengthColor(password);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: password.length / 16,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(color),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Strength: $strength',
            style: TextStyle(
              fontSize: 12,
              color: Color(color),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Build success message card
  Widget _buildSuccessMessage(ProfileFormData data) {
    return Container(
      margin: const EdgeInsets.all(16),
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
              Icon(
                Icons.check_circle,
                color: Colors.green.shade700,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Profile Saved Successfully!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.green.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataRow('Full Name', data.fullName),
                _buildDataRow('Email', data.email),
                _buildDataRow('Phone', data.phoneNumber),
                _buildDataRow('Account Status', 'Active'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build data display row
  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
