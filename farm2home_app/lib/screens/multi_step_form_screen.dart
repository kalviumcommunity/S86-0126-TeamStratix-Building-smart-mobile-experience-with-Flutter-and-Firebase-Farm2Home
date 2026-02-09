import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validators.dart';

/// Multi-step form demonstration for complex data collection
///
/// This example shows how to break down a large form into multiple steps
/// with validation at each stage before allowing progression.
class MultiStepFormScreen extends StatefulWidget {
  const MultiStepFormScreen({super.key});

  @override
  State<MultiStepFormScreen> createState() => _MultiStepFormScreenState();
}

class _MultiStepFormScreenState extends State<MultiStepFormScreen> {
  int _currentStep = 0;

  // Form keys for each step
  final _personalInfoFormKey = GlobalKey<FormState>();
  final _addressFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  // Step 1: Personal Information
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Step 2: Address Information
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Step 3: Payment Information
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _obscureCvv = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _nextStep() {
    bool isValid = false;

    switch (_currentStep) {
      case 0:
        isValid = _personalInfoFormKey.currentState!.validate();
        break;
      case 1:
        isValid = _addressFormKey.currentState!.validate();
        break;
      case 2:
        isValid = _paymentFormKey.currentState!.validate();
        break;
    }

    if (isValid) {
      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
      } else {
        _submitForm();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete all required fields'),
          backgroundColor: Colors.orange[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _submitForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[700], size: 28),
            const SizedBox(width: 12),
            const Text('Order Confirmed!'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your order has been placed successfully!',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              const Text(
                'Order Summary:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildSummarySection('Personal Information', [
                'Name: ${_firstNameController.text} ${_lastNameController.text}',
                'Email: ${_emailController.text}',
                'Phone: ${_phoneController.text}',
              ]),
              const SizedBox(height: 12),
              _buildSummarySection('Shipping Address', [
                _streetController.text,
                '${_cityController.text}, ${_stateController.text} ${_zipController.text}',
              ]),
              const SizedBox(height: 12),
              _buildSummarySection('Payment', [
                'Card: **** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}',
                'Cardholder: ${_cardHolderController.text}',
              ]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 2),
            child: Text(item, style: const TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }

  void _resetForm() {
    setState(() {
      _currentStep = 0;
    });

    _personalInfoFormKey.currentState?.reset();
    _addressFormKey.currentState?.reset();
    _paymentFormKey.currentState?.reset();

    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _streetController.clear();
    _cityController.clear();
    _stateController.clear();
    _zipController.clear();
    _cardNumberController.clear();
    _cardHolderController.clear();
    _expiryController.clear();
    _cvvController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multi-Step Form'),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            color: Colors.green[700],
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Personal', Icons.person),
                _buildStepConnector(0),
                _buildStepIndicator(1, 'Address', Icons.location_on),
                _buildStepConnector(1),
                _buildStepIndicator(2, 'Payment', Icons.payment),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStepForm(),
            ),
          ),

          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.green[700]!),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  flex: _currentStep == 0 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Submit Order' : 'Next',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = step <= _currentStep;
    final isCurrent = step == _currentStep;

    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.green[300],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: isCurrent ? 3 : 2),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.green[700] : Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int step) {
    final isActive = step < _currentStep;

    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 28),
        color: isActive ? Colors.white : Colors.green[300],
      ),
    );
  }

  Widget _buildCurrentStepForm() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoForm();
      case 1:
        return _buildAddressForm();
      case 2:
        return _buildPaymentForm();
      default:
        return const SizedBox();
    }
  }

  Widget _buildPersonalInfoForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _personalInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tell us about yourself',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _firstNameController,
                decoration: _inputDecoration('First Name', Icons.person),
                validator: (value) =>
                    Validators.required(value, fieldName: 'First name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lastNameController,
                decoration: _inputDecoration('Last Name', Icons.person_outline),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Last name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email Address', Icons.email),
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Phone Number', Icons.phone),
                validator: Validators.phoneNumber,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _addressFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping Address',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Where should we deliver?',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _streetController,
                decoration: _inputDecoration('Street Address', Icons.home),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Street address'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: _inputDecoration('City', Icons.location_city),
                validator: (value) =>
                    Validators.required(value, fieldName: 'City'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: _inputDecoration('State', Icons.map),
                      validator: (value) =>
                          Validators.required(value, fieldName: 'State'),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _zipController,
                      decoration: _inputDecoration(
                        'ZIP Code',
                        Icons.markunread_mailbox,
                      ),
                      validator: Validators.zipCode,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _paymentFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Secure payment processing',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _cardNumberController,
                decoration: _inputDecoration('Card Number', Icons.credit_card),
                validator: Validators.creditCard,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cardHolderController,
                decoration: _inputDecoration('Cardholder Name', Icons.person),
                validator: (value) =>
                    Validators.required(value, fieldName: 'Cardholder name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: _inputDecoration(
                        'Expiry (MM/YY)',
                        Icons.calendar_today,
                      ),
                      validator: _validateExpiry,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateFormatter(),
                      ],
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: _inputDecoration('CVV', Icons.lock).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureCvv
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureCvv = !_obscureCvv;
                            });
                          },
                        ),
                      ),
                      validator: Validators.cvv,
                      obscureText: _obscureCvv,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your payment information is encrypted and secure',
                        style: TextStyle(fontSize: 12, color: Colors.blue[900]),
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green[700]),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green[700]!, width: 2),
      ),
    );
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    if (value.length != 5) {
      return 'Enter valid expiry (MM/YY)';
    }

    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Enter valid expiry (MM/YY)';
    }

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null || month < 1 || month > 12) {
      return 'Invalid month';
    }

    final now = DateTime.now();
    final expiry = DateTime(2000 + year, month);

    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }

    return null;
  }
}

/// Custom formatter for card number (adds spaces every 4 digits)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Custom formatter for expiry date (adds / after 2 digits)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');

    if (text.length >= 2) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return newValue;
  }
}
