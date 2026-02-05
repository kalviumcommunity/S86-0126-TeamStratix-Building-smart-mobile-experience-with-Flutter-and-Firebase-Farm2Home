import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// Assets Management Demo Screen
/// 
/// Demonstrates how to manage, register, and display:
/// - Local images using Image.asset()
/// - Built-in Flutter Material Icons
/// - iOS-style Cupertino Icons
/// - Combining images and icons in layouts
class AssetsManagementDemo extends StatelessWidget {
  const AssetsManagementDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets & Icons Management'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section 1: Asset Setup Info
            _buildSetupInfoSection(),
            
            const SizedBox(height: 24),
            
            // Section 2: Material Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Material Icons', Icons.dashboard),
            ),
            _buildMaterialIconsSection(),
            
            const SizedBox(height: 24),
            
            // Section 3: Cupertino Icons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Cupertino Icons (iOS)', CupertinoIcons.heart),
            ),
            _buildCupertinoIconsSection(),
            
            const SizedBox(height: 24),
            
            // Section 4: Icon Sizing Examples
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Icon Sizing', Icons.text_fields),
            ),
            _buildIconSizingSection(),
            
            const SizedBox(height: 24),
            
            // Section 5: Icon Styling
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Icon Styling & Colors', Icons.color_lens),
            ),
            _buildIconStylingSection(),
            
            const SizedBox(height: 24),
            
            // Section 6: Placeholder Images (Asset examples)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Local Image Assets', Icons.image),
            ),
            _buildImageAssetsSection(),
            
            const SizedBox(height: 24),
            
            // Section 7: Combined Layout Examples
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Combined Layouts', Icons.widgets),
            ),
            _buildCombinedLayoutsSection(),
            
            const SizedBox(height: 24),
            
            // Section 8: Asset Configuration Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildSectionHeader('Asset Configuration', Icons.settings),
            ),
            _buildAssetConfigSection(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Section 1: Asset Setup Information
  Widget _buildSetupInfoSection() {
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
            'Asset Setup Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoPoint(
            '📁 Folder Structure',
            'assets/images/ and assets/icons/',
          ),
          _buildInfoPoint(
            '⚙️ Registration',
            'Configured in pubspec.yaml under flutter: assets:',
          ),
          _buildInfoPoint(
            '🖼️ Image Loading',
            'Use Image.asset("assets/images/filename.png")',
          ),
          _buildInfoPoint(
            '🎨 Built-in Icons',
            '1000+ Material icons from Icons class (no registration needed)',
          ),
        ],
      ),
    );
  }

  /// Helper: Info point
  Widget _buildInfoPoint(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Section 2: Material Icons Examples
  Widget _buildMaterialIconsSection() {
    final icons = [
      (Icons.home, 'Home'),
      (Icons.shopping_cart, 'Cart'),
      (Icons.favorite, 'Favorite'),
      (Icons.star, 'Star'),
      (Icons.settings, 'Settings'),
      (Icons.search, 'Search'),
      (Icons.logout, 'Logout'),
      (Icons.notifications, 'Notifications'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Common Material Icons',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: icons
                    .map(
                      (item) => Column(
                        children: [
                          Icon(
                            item.$1,
                            size: 32,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.$2,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 3: Cupertino Icons Examples
  Widget _buildCupertinoIconsSection() {
    final cupertinoIcons = [
      (CupertinoIcons.heart, 'Heart'),
      (CupertinoIcons.star, 'Star'),
      (CupertinoIcons.home, 'Home'),
      (CupertinoIcons.person, 'Person'),
      (CupertinoIcons.search, 'Search'),
      (CupertinoIcons.settings, 'Settings'),
      (CupertinoIcons.mail, 'Mail'),
      (CupertinoIcons.bell, 'Bell'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'iOS-style Cupertino Icons',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: cupertinoIcons
                    .map(
                      (item) => Column(
                        children: [
                          Icon(
                            item.$1,
                            size: 32,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.$2,
                            style: const TextStyle(fontSize: 11),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 4: Icon Sizing Examples
  Widget _buildIconSizingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Icon Size Variations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Column(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('Small (16)', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, size: 24, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('Normal (24)', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, size: 32, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('Large (32)', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, size: 48, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('XL (48)', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.star, size: 64, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('XXL (64)', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 5: Icon Styling Examples
  Widget _buildIconStylingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Icon Colors & Styles',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  Column(
                    children: [
                      Icon(Icons.favorite, size: 32, color: Colors.red),
                      const SizedBox(height: 4),
                      const Text('Red', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, size: 32, color: Colors.blue),
                      const SizedBox(height: 4),
                      const Text('Blue', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, size: 32, color: Colors.green),
                      const SizedBox(height: 4),
                      const Text('Green', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, size: 32, color: Colors.amber),
                      const SizedBox(height: 4),
                      const Text('Amber', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.favorite, size: 32, color: Colors.purple),
                      const SizedBox(height: 4),
                      const Text('Purple', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 6: Local Image Assets
  Widget _buildImageAssetsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Local Image Asset Placeholders',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Image 1: Logo placeholder
              Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'assets/images/logo.png',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add your app logo here (200x200px)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Image 2: Banner placeholder
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.landscape,
                      size: 40,
                      color: Colors.orange.shade600,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'assets/images/banner.png',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      '1200x400px banner for hero sections',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
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

  /// Section 7: Combined Layouts Examples
  Widget _buildCombinedLayoutsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Layout 1: Product Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Product Card Layout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Organic Tomatoes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fresh from farm',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.5 (128 reviews)',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        size: 24,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Layout 2: Feature Row
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Feature Row Layout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            size: 32,
                            color: Colors.green.shade600,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Free Delivery',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.verified_user,
                            size: 32,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Verified',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.security,
                            size: 32,
                            color: Colors.purple.shade600,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Secure',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(
                            Icons.support_agent,
                            size: 32,
                            color: Colors.orange.shade600,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '24/7 Support',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section 8: Asset Configuration Info
  Widget _buildAssetConfigSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'pubspec.yaml Configuration',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  '''flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/''',
                  style: TextStyle(
                    color: Colors.green.shade400,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Key Points:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint('Use 2 spaces for indentation (YAML requirement)'),
              _buildBulletPoint('List folder paths with trailing slash'),
              _buildBulletPoint('Run "flutter pub get" after adding new assets'),
              _buildBulletPoint('Use Image.asset("assets/path/file.png") in code'),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: Bullet point
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: Section Header
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
