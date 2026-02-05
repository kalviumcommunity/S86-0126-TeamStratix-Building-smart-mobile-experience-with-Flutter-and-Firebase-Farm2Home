import 'package:flutter/material.dart';

/// Comprehensive responsive design demo using MediaQuery and LayoutBuilder
/// 
/// This screen demonstrates:
/// - Dynamic sizing with MediaQuery
/// - Conditional layouts with LayoutBuilder
/// - Responsive grids that adapt to screen size
/// - Flexible spacing based on device dimensions
/// - Orientation-aware UI adjustments
class ResponsiveDesignDemo extends StatefulWidget {
  const ResponsiveDesignDemo({super.key});

  @override
  State<ResponsiveDesignDemo> createState() => _ResponsiveDesignDemoState();
}

class _ResponsiveDesignDemoState extends State<ResponsiveDesignDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Design Demo'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Screen info section
            _buildScreenInfoSection(context),
            
            const SizedBox(height: 24),
            
            // MediaQuery demo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('MediaQuery Examples', Icons.aspect_ratio),
            ),
            _buildMediaQueryDemo(context),
            
            const SizedBox(height: 24),
            
            // LayoutBuilder demo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('LayoutBuilder Examples', Icons.dashboard),
            ),
            _buildLayoutBuilderDemo(),
            
            const SizedBox(height: 24),
            
            // Responsive grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Responsive Grid', Icons.grid_3x3),
            ),
            _buildResponsiveGrid(context),
            
            const SizedBox(height: 24),
            
            // Responsive form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Responsive Form', Icons.description),
            ),
            _buildResponsiveForm(context),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Builds screen information display
  Widget _buildScreenInfoSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Device Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Width', '${screenWidth.toStringAsFixed(0)} px'),
          _buildInfoRow('Height', '${screenHeight.toStringAsFixed(0)} px'),
          _buildInfoRow('Orientation', orientation.name.toUpperCase()),
          _buildInfoRow('Device Pixel Ratio', devicePixelRatio.toStringAsFixed(2)),
          _buildInfoRow(
            'Device Type',
            screenWidth < 600 ? '📱 Phone' : '📱 Tablet',
          ),
        ],
      ),
    );
  }

  /// Builds info row for display
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds MediaQuery demonstration examples
  Widget _buildMediaQueryDemo(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Example 1: Proportional sizing
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 1: Proportional Sizing',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: screenWidth * 0.85,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Takes 85% of screen width',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Width: ${(screenWidth * 0.85).toStringAsFixed(0)} px',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Example 2: Dynamic padding
          Card(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 2: Dynamic Padding',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'This box has padding of ${(screenWidth * 0.04).toStringAsFixed(0)} px',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Example 3: Responsive font size
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Example 3: Responsive Font Size',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Adaptive Text',
                    style: TextStyle(
                      fontSize: screenWidth > 800 ? 32 : screenWidth > 600 ? 24 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Font size adjusts based on screen width',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds LayoutBuilder demonstration
  Widget _buildLayoutBuilderDemo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layout: ${isMobile ? 'Mobile (Vertical)' : 'Tablet (Horizontal)'}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  if (isMobile)
                    // Mobile layout - vertical stack
                    Column(
                      children: [
                        _buildLayoutBox('Section 1', Colors.blue.shade300),
                        const SizedBox(height: 12),
                        _buildLayoutBox('Section 2', Colors.green.shade300),
                        const SizedBox(height: 12),
                        _buildLayoutBox('Section 3', Colors.orange.shade300),
                      ],
                    )
                  else
                    // Tablet layout - horizontal
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLayoutBox('Section 1', Colors.blue.shade300),
                        _buildLayoutBox('Section 2', Colors.green.shade300),
                        _buildLayoutBox('Section 3', Colors.orange.shade300),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Max width: ${constraints.maxWidth.toStringAsFixed(0)} px',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds responsive grid layout
  Widget _buildResponsiveGrid(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine columns based on screen width
    int columns;
    if (screenWidth < 600) {
      columns = 2; // Mobile: 2 columns
    } else if (screenWidth < 900) {
      columns = 3; // Tablet: 3 columns
    } else {
      columns = 4; // Desktop: 4 columns
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grid: $columns columns',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: columns,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  8,
                  (index) => Container(
                    decoration: BoxDecoration(
                      color: Colors.primaries[index % Colors.primaries.length],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Item ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds responsive form layout
  Widget _buildResponsiveForm(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Layout: ${isMobile ? 'Stacked' : 'Side-by-side'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  if (isMobile)
                    // Mobile form - stacked
                    Column(
                      children: [
                        _buildFormField('Full Name'),
                        const SizedBox(height: 12),
                        _buildFormField('Email'),
                        const SizedBox(height: 12),
                        _buildFormField('Phone'),
                      ],
                    )
                  else
                    // Tablet form - side by side
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildFormField('First Name')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildFormField('Last Name')),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildFormField('Email'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _buildFormField('Phone')),
                            const SizedBox(width: 12),
                            Expanded(child: _buildFormField('City')),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds a layout box for demonstration
  Widget _buildLayoutBox(String label, Color color) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  /// Builds form field widget
  Widget _buildFormField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  /// Builds section header
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.green.shade700),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade700,
          ),
        ),
      ],
    );
  }
}
