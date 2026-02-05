import 'package:flutter/material.dart';

/// Responsive form layout screen demonstrating adaptive form layouts
/// 
/// Demonstrates how to create forms that stack vertically on mobile
/// and display side-by-side on tablets using LayoutBuilder and MediaQuery.
class ResponsiveFormLayout extends StatefulWidget {
  const ResponsiveFormLayout({super.key});

  @override
  State<ResponsiveFormLayout> createState() => _ResponsiveFormLayoutState();
}

class _ResponsiveFormLayoutState extends State<ResponsiveFormLayout> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Form Layout'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Form layout indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Form Layout Info',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Screen width: ${screenWidth.toStringAsFixed(0)} px',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      screenWidth < 600
                          ? 'Layout: Stacked (Mobile) - Single column'
                          : 'Layout: Side-by-side (Tablet) - Multiple columns',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Responsive form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name section - responsive layout
                    _buildResponsiveNameFields(),

                    const SizedBox(height: 16),

                    // Contact section
                    _buildContactFields(),

                    const SizedBox(height: 16),

                    // Address section
                    _buildAddressSection(),

                    const SizedBox(height: 24),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _submitForm,
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds responsive name fields (single column on mobile, two columns on tablet)
  Widget _buildResponsiveNameFields() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          // Mobile layout - stacked
          return Column(
            children: [
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                icon: Icons.person,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                icon: Icons.person,
                validator: _requiredValidator,
              ),
            ],
          );
        } else {
          // Tablet layout - side by side
          return Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person,
                  validator: _requiredValidator,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person,
                  validator: _requiredValidator,
                ),
              ),
            ],
          );
        }
      },
    );
  }

  /// Builds contact fields section
  Widget _buildContactFields() {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: _emailValidator,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: _phoneValidator,
        ),
      ],
    );
  }

  /// Builds responsive address section
  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildTextField(
          controller: _addressController,
          label: 'Street Address',
          icon: Icons.location_on,
          validator: _requiredValidator,
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;

            if (isMobile) {
              // Mobile layout - stacked
              return Column(
                children: [
                  _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_city,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    icon: Icons.map,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _zipController,
                    label: 'ZIP Code',
                    icon: Icons.markunread_mailbox,
                    validator: _requiredValidator,
                  ),
                ],
              );
            } else {
              // Tablet layout - three columns
              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextField(
                      controller: _cityController,
                      label: 'City',
                      icon: Icons.location_city,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildTextField(
                      controller: _stateController,
                      label: 'State',
                      icon: Icons.map,
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: _buildTextField(
                      controller: _zipController,
                      label: 'ZIP Code',
                      icon: Icons.markunread_mailbox,
                      validator: _requiredValidator,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  /// Builds a text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      validator: validator,
    );
  }

  /// Validators
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone is required';
    }
    if (value.length < 10) {
      return 'Phone should be at least 10 digits';
    }
    return null;
  }

  /// Submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Form submitted successfully!'),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Clear form
      _formKey.currentState!.reset();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();
      _cityController.clear();
      _stateController.clear();
      _zipController.clear();
    }
  }
}
