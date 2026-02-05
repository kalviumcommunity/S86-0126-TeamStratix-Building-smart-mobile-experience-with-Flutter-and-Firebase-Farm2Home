# 🏗️ Widget Architecture Overview

## Widget Hierarchy & Composition

```
InfoCard (StatelessWidget)
├── Uses: Card, InkWell, Icon, Text
├── Reusable: Information display
└── Variants: Color customizable, optional onTap

CustomButton (StatelessWidget)
├── Uses: ElevatedButton, OutlinedButton, TextButton
├── Variants: Primary, Secondary, Outlined, Text
├── Features: Icon, Loading state, Full-width
└── Reusable: All button interactions

LikeButton (StatefulWidget)
├── Uses: GestureDetector, AnimationController
├── Manages: Like/unlike state
├── Animation: Scale transition on toggle
├── Reusable: Favorite interactions
└── Callbacks: onLikeChanged

RatingWidget (StatelessWidget)
├── Uses: Icon (star, star_half, star_border)
├── Features: Partial ratings, review count
└── Reusable: All rating displays

ProductCard (StatelessWidget)
├── Composition:
│   ├── Image (with error handling)
│   ├── Favorite Overlay (uses LikeButton)
│   ├── Discount Badge
│   ├── Title & Description
│   ├── Rating (uses RatingWidget)
│   ├── Price (with discount strikethrough)
│   └── Add to Cart Button
├── Callbacks: onTap, onAddToCart, onFavorite
└── Reusable: Grid, list, detail layouts

ProductCardCompact (StatelessWidget)
├── Composition:
│   ├── Image (horizontal)
│   ├── Title
│   ├── Rating (uses RatingWidget)
│   ├── Price
│   └── Add Button
└── Reusable: List, carousel layouts
```

## Composition Example

### ProductCard uses multiple widgets:

```
ProductCard
├── Stack
│   ├── Image.network/asset
│   ├── Discount Badge (Container + Text)
│   └── LikeButton (Positioned)
└── Column
    ├── Title (Text)
    ├── Description (Text)
    ├── RatingWidget
    └── Row
        ├── Price Column
        └── Add to Cart Button
```

## Widget Parameters

### InfoCard Props
```dart
String title           // Required
String subtitle        // Required
IconData icon          // Required
VoidCallback? onTap
Color? iconColor
Color? backgroundColor
```

### CustomButton Props
```dart
String text                    // Required
VoidCallback? onPressed        // Required
ButtonVariant variant
IconData? icon
bool fullWidth
bool isLoading
```

### LikeButton Props
```dart
bool initiallyLiked
ValueChanged<bool>? onLikeChanged
double size
Color? likedColor
```

### ProductCard Props
```dart
String imageUrl                    // Required
String title                       // Required
double price                       // Required
String? description
double rating
int reviewCount
VoidCallback? onAddToCart
VoidCallback? onTap
ValueChanged<bool>? onFavorite
bool isFavorited
int? discountPercent
```

## Usage Patterns

### Pattern 1: Simple List of Same Widget
```dart
ListView(
  children: [
    InfoCard(...),
    InfoCard(...),
    InfoCard(...),
  ],
)
```

### Pattern 2: Widget with Callbacks
```dart
CustomButton(
  onPressed: () {
    // Handle action
  },
  onFavorite: (liked) {
    // Update state
  },
)
```

### Pattern 3: Composition of Widgets
```dart
ProductCard  // Uses LikeButton + RatingWidget
├── LikeButton
└── RatingWidget
```

### Pattern 4: Stateful Interaction
```dart
// LikeButton manages its own state
// Parent doesn't need to manage it
LikeButton(
  onLikeChanged: (newValue) {
    // React to change if needed
  },
)
```

## Reusability Metrics

### InfoCard
- **Single Responsibility:** Display info with icon
- **Reuse Count:** 3+ instances in demo
- **Customization:** Icon, color, text, callback
- **Screen Usage:** Navigation, menu, info displays

### CustomButton
- **Single Responsibility:** Button interaction
- **Variants:** 4 different styles
- **Reuse Count:** 5+ instances in demo
- **Screen Usage:** Forms, actions, confirmations

### LikeButton
- **Single Responsibility:** Favorite toggle
- **State Management:** Internal
- **Reuse Count:** 3+ instances in demo
- **Screen Usage:** Products, favorites, details

### ProductCard
- **Composite Responsibility:** Product display
- **Composed Of:** Image, price, rating, favorite
- **Variants:** Standard and compact
- **Reuse Count:** Used across multiple screens

## Best Practices Demonstrated

✅ **Single Responsibility Principle**
- Each widget does one thing well
- Easy to test and maintain

✅ **Composition Over Inheritance**
- ProductCard uses LikeButton + RatingWidget
- More flexible than inheritance

✅ **Const Constructor**
- All widgets use const constructors
- Enables tree comparison optimization

✅ **Optional Parameters**
- Sensible defaults for all optional props
- Flexible API without overwhelming options

✅ **Documentation**
- Usage examples in code comments
- Parameter descriptions
- Clear naming

✅ **State Management**
- LikeButton manages internal state
- Callbacks for parent notification
- Separates local from app state

## Extension Points

### Adding New Button Variant
```dart
// In custom_button.dart
case ButtonVariant.danger:
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
    ),
    child: content,
  );
```

### Adding New InfoCard Color
```dart
// Already supported through iconColor param
InfoCard(
  iconColor: Colors.purple,  // Any color!
)
```

### Adding New ProductCard Feature
```dart
// Add badge support
class ProductCard extends StatelessWidget {
  final String? badge;  // NEW
  
  // Implement badge display in Stack
}
```

## Performance Considerations

### Widget Rebuilds
- Const constructors prevent unnecessary rebuilds
- LikeButton isolates state to small widget
- Parent rebuilds don't affect LikeButton unless prop changes

### Memory
- Widgets are lightweight
- Animations use single AnimationController
- Images cached by Flutter engine

### Rendering
- Efficient tree structure
- Minimal nesting
- Optimized layout constraints

## Testing Opportunities

Each widget can be unit tested:

```dart
testWidgets('InfoCard renders correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: InfoCard(
          title: 'Test',
          subtitle: 'Test',
          icon: Icons.star,
        ),
      ),
    ),
  );
  expect(find.text('Test'), findsWidgets);
});
```

## Migration Path

If moving to state management solutions (Provider, Riverpod):

### Before (Local State)
```dart
LikeButton(
  initiallyLiked: false,
  onLikeChanged: (liked) {
    _updateServer(liked);
  },
)
```

### After (Provider)
```dart
// Widget still same, but state managed externally
LikeButton(
  initiallyLiked: model.isFavorited,
  onLikeChanged: (liked) {
    model.toggleFavorite(liked);
  },
)
```

---

This architecture demonstrates professional Flutter development patterns suitable for large-scale applications.
