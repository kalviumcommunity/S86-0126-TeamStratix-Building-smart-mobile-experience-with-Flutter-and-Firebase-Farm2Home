import 'package:flutter/material.dart';
import '../services/cloud_function_service.dart';

/// Cloud Functions Demo Screen
/// Demonstrates callable Cloud Functions and event triggers
class CloudFunctionsDemoScreen extends StatefulWidget {
  const CloudFunctionsDemoScreen({super.key});

  @override
  State<CloudFunctionsDemoScreen> createState() =>
      _CloudFunctionsDemoScreenState();
}

class _CloudFunctionsDemoScreenState extends State<CloudFunctionsDemoScreen> {
  final CloudFunctionService _functionService = CloudFunctionService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberAController = TextEditingController();
  final TextEditingController _numberBController = TextEditingController();

  bool _isLoading = false;
  String? _lastResponse;
  String? _errorMessage;
  final List<String> _callHistory = [];

  @override
  void dispose() {
    _nameController.dispose();
    _numberAController.dispose();
    _numberBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Functions Demo'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            _buildInfoCard(),
            const SizedBox(height: 20),

            // Function examples
            _buildFunctionExamples(),
            const SizedBox(height: 24),

            // Response display
            _buildResponseSection(),
            const SizedBox(height: 16),

            // Call history
            _buildCallHistory(),
          ],
        ),
      ),
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.purple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cloud Functions Demo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Firebase Cloud Functions allow you to run backend logic without managing servers. '
              'This demo shows:',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 8),
            const Text(
              '✓ Callable functions invoked from Flutter\n'
              '✓ Real-time response handling\n'
              '✓ Error management\n'
              '✓ Server-side computation',
              style: TextStyle(fontSize: 11),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '💡 Check Firebase Console → Functions → Logs to see function execution',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build function examples section
  Widget _buildFunctionExamples() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Callable Functions',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Say Hello
            _buildFunctionExample(
              title: 'Say Hello',
              controller: _nameController,
              hint: 'Enter your name',
              buttonLabel: 'Call sayHello()',
              onPressed: _callSayHello,
            ),
            const SizedBox(height: 16),

            // Calculate Sum
            _buildCalculateSum(),
            const SizedBox(height: 16),

            // Get Server Time
            _buildServerTimeButton(),
          ],
        ),
      ),
    );
  }

  /// Build single function example
  Widget _buildFunctionExample({
    required String title,
    required TextEditingController controller,
    required String hint,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(buttonLabel),
          ),
        ),
      ],
    );
  }

  /// Build calculate sum section
  Widget _buildCalculateSum() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calculate Sum',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _numberAController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number A',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('+'),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _numberBController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Number B',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _callCalculateSum,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: const Text('Call calculateSum()'),
          ),
        ),
      ],
    );
  }

  /// Build server time button
  Widget _buildServerTimeButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _callGetServerTime,
        icon: const Icon(Icons.schedule),
        label: const Text('Get Server Time'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  /// Build response section
  Widget _buildResponseSection() {
    return Card(
      elevation: 2,
      color: _errorMessage != null ? Colors.red.shade50 : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Response',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            if (_lastResponse == null && _errorMessage == null)
              Center(
                child: Text(
                  'Call a function to see response here',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Success',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      _lastResponse ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build call history section
  Widget _buildCallHistory() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Call History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (_callHistory.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _callHistory.clear()),
                    child: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_callHistory.isEmpty)
              Center(
                child: Text(
                  'No calls made yet',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _callHistory.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _callHistory[index],
                      style: const TextStyle(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // Function call handlers

  /// Call sayHello function
  Future<void> _callSayHello() async {
    if (_nameController.text.isEmpty) {
      _showError('Please enter a name');
      return;
    }

    _setLoading(true);
    final response =
        await _functionService.callSayHello(_nameController.text);
    _handleResponse(response, 'sayHello');
    _setLoading(false);
  }

  /// Call calculateSum function
  Future<void> _callCalculateSum() async {
    if (_numberAController.text.isEmpty || _numberBController.text.isEmpty) {
      _showError('Please enter both numbers');
      return;
    }

    _setLoading(true);
    final a = int.tryParse(_numberAController.text) ?? 0;
    final b = int.tryParse(_numberBController.text) ?? 0;
    final response = await _functionService.calculateSum(a, b);
    _handleResponse(response, 'calculateSum($a, $b)');
    _setLoading(false);
  }

  /// Call getServerTime function
  Future<void> _callGetServerTime() async {
    _setLoading(true);
    final response = await _functionService.getServerTime();
    _handleResponse(response, 'getServerTime()');
    _setLoading(false);
  }

  // Helper methods

  /// Handle function response
  void _handleResponse(CloudFunctionResponse response, String functionName) {
    setState(() {
      if (response.success) {
        _lastResponse = response.data.toString();
        _errorMessage = null;
        _addToHistory('✓ $functionName → ${response.data}');
        _showSuccess('Function executed successfully');
      } else {
        _lastResponse = null;
        _errorMessage = response.error;
        _addToHistory('✗ $functionName → ${response.error}');
      }
    });
  }

  /// Set loading state
  void _setLoading(bool value) {
    setState(() => _isLoading = value);
  }

  /// Add to call history
  void _addToHistory(String entry) {
    setState(() {
      _callHistory.insert(
        0,
        '${DateTime.now().toString().split('.')[0]} - $entry',
      );
      if (_callHistory.length > 20) {
        _callHistory.removeLast();
      }
    });
  }

  /// Show error message
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show success message
  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
