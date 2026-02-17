import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/cart_provider.dart';
import '../../models/product_model.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/search_bar.dart' as custom;
import '../../widgets/filter_widgets.dart';
import '../../widgets/responsive_widgets.dart';
import '../../core/app_breakpoints.dart';
import '../../core/error_handler.dart';
import '../../core/validators.dart';

class ImprovedProductsScreen extends StatefulWidget {
  const ImprovedProductsScreen({super.key});

  @override
  State<ImprovedProductsScreen> createState() => _ImprovedProductsScreenState();
}

class _ImprovedProductsScreenState extends State<ImprovedProductsScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _sortBy = 'Name'; // Name, Price Low-High, Price High-Low
  
  final List<String> _categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Dairy & Eggs',
    'Grains',
    'Others',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ProductModel> _filterAndSortProducts(List<ProductModel> products) {
    var filtered = products;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.farmerName.toLowerCase().contains(query);
      }).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'Price Low-High':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price High-Low':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Name':
      default:
        filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar
          custom.SearchBar(
            controller: _searchController,
            hintText: 'Search products, farmers...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),

          // Filter & Sort Row
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsivePadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.sort),
                  tooltip: 'Sort by',
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Name',
                      child: Text('Name'),
                    ),
                    const PopupMenuItem(
                      value: 'Price Low-High',
                      child: Text('Price: Low to High'),
                    ),
                    const PopupMenuItem(
                      value: 'Price High-Low',
                      child: Text('Price: High to Low'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category Filter
          FilterChipGroup(
            options: _categories,
            selectedOption: _selectedCategory,
            onSelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),

          const SizedBox(height: AppSpacing.sm),

          // Products Grid
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: Provider.of<CartProvider>(
                context,
                listen: false,
              ).streamProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget(message: 'Loading products...');
                }

                if (snapshot.hasError) {
                  return ErrorStateWidget(
                    message: 'Failed to load products',
                    onRetry: () {
                      setState(() {});
                    },
                  );
                }

                final allProducts = snapshot.data ?? [];
                final filteredProducts = _filterAndSortProducts(allProducts);

                if (filteredProducts.isEmpty) {
                  return EmptyStateWidget(
                    message: _searchQuery.isNotEmpty
                        ? 'No products found'
                        : _selectedCategory == 'All'
                            ? 'No products available yet'
                            : 'No products in this category',
                    subtitle: _searchQuery.isNotEmpty
                        ? 'Try different search terms'
                        : 'Farmers will add products soon!',
                    icon: Icons.shopping_basket_outlined,
                  );
                }

                return ResponsiveGrid(
                  childAspectRatio: 0.75,
                  children: filteredProducts
                      .map((product) => _ProductCard(product: product))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  Future<void> _showAddToCartDialog(BuildContext context) async {
    final quantityController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Add ${product.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price: \$${product.price.toStringAsFixed(2)} per ${product.unit}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantity (${product.unit})',
                ),
                validator: (value) => Validators.positiveNumber(
                  value,
                  fieldName: 'Quantity',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final quantity = double.parse(quantityController.text);
      
      try {
        Provider.of<CartProvider>(
          context,
          listen: false,
        ).addToCart(product, quantity);

        AppNotification.showSuccess(
          context,
          '${product.name} added to cart',
        );
      } catch (e) {
        ErrorHandler.handleError(e, null, context: context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/product-detail',
            arguments: product.productId,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            AspectRatio(
              aspectRatio: 1.3,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.shopping_basket,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'by ${product.farmerName}',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () => _showAddToCartDialog(context),
                          tooltip: 'Add to cart',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
