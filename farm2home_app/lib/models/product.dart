/// Product model for Farm2Home app
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;
  final String category;
  final String imageIcon;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageIcon,
  });
}

/// Sample products data
final List<Product> sampleProducts = [
  Product(
    id: '1',
    name: 'Fresh Tomatoes',
    description: 'Organic, locally grown tomatoes',
    price: 3.99,
    unit: 'per lb',
    category: 'Vegetables',
    imageIcon: '🍅',
  ),
  Product(
    id: '2',
    name: 'Green Lettuce',
    description: 'Crisp and fresh lettuce heads',
    price: 2.49,
    unit: 'per head',
    category: 'Vegetables',
    imageIcon: '🥬',
  ),
  Product(
    id: '3',
    name: 'Carrots',
    description: 'Sweet, crunchy carrots',
    price: 2.99,
    unit: 'per bunch',
    category: 'Vegetables',
    imageIcon: '🥕',
  ),
  Product(
    id: '4',
    name: 'Fresh Apples',
    description: 'Red delicious apples',
    price: 4.99,
    unit: 'per lb',
    category: 'Fruits',
    imageIcon: '🍎',
  ),
  Product(
    id: '5',
    name: 'Strawberries',
    description: 'Sweet, ripe strawberries',
    price: 5.99,
    unit: 'per basket',
    category: 'Fruits',
    imageIcon: '🍓',
  ),
  Product(
    id: '6',
    name: 'Fresh Milk',
    description: 'Farm fresh whole milk',
    price: 4.49,
    unit: 'per gallon',
    category: 'Dairy',
    imageIcon: '🥛',
  ),
  Product(
    id: '7',
    name: 'Farm Eggs',
    description: 'Free-range chicken eggs',
    price: 6.99,
    unit: 'per dozen',
    category: 'Dairy',
    imageIcon: '🥚',
  ),
  Product(
    id: '8',
    name: 'Broccoli',
    description: 'Fresh green broccoli crowns',
    price: 3.49,
    unit: 'per head',
    category: 'Vegetables',
    imageIcon: '🥦',
  ),
];
