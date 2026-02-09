# State Management Quick Reference ⚡

## 🎯 Quick Setup

### 1. Add Provider Dependency
```yaml
dependencies:
  provider: ^6.1.0
```

### 2. Install
```bash
flutter pub get
```

---

## 📦 Creating a State Class

```dart
import 'package:flutter/foundation.dart';

class CounterState extends ChangeNotifier {
  int _count = 0;
  
  int get count => _count;
  
  void increment() {
    _count++;
    notifyListeners(); // Triggers UI rebuild
  }
}
```

**Key Points:**
- Extend `ChangeNotifier`
- Private fields with public getters
- Call `notifyListeners()` after state changes

---

## 🌳 Register Providers at App Root

### Single Provider
```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CounterState(),
      child: const MyApp(),
    ),
  );
}
```

### Multiple Providers
```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => FavoritesService()),
        ChangeNotifierProvider(create: (_) => AppThemeService()),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## 📖 Reading State in Widgets

### Method 1: `context.watch<T>()` (Rebuilds on change)
```dart
@override
Widget build(BuildContext context) {
  final counter = context.watch<CounterState>();
  return Text('Count: ${counter.count}');
}
```
✅ Use when: Widget needs to rebuild on state changes

### Method 2: `context.read<T>()` (No rebuild)
```dart
ElevatedButton(
  onPressed: () {
    context.read<CounterState>().increment();
  },
  child: Text('Increment'),
)
```
✅ Use when: Only calling methods, no need to rebuild

### Method 3: `Consumer<T>` (Rebuild only subtree)
```dart
Consumer<CounterState>(
  builder: (context, counter, child) {
    return Text('Count: ${counter.count}');
  },
)
```
✅ Use when: Want to rebuild only specific widget

---

## 🔄 Common Patterns

### Cart Management
```dart
class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];
  
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }
  
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
```

### Favorites List
```dart
class FavoritesService extends ChangeNotifier {
  final List<String> _favoriteIds = [];
  
  bool isFavorite(String id) => _favoriteIds.contains(id);
  
  void toggleFavorite(String id) {
    if (isFavorite(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}
```

---

## 🔀 Multi-Screen Shared State

### Screen A (Add data)
```dart
context.read<FavoritesService>().addFavorite('product_123');
```

### Screen B (Display data)
```dart
Consumer<FavoritesService>(
  builder: (context, favorites, _) {
    return ListView(
      children: favorites.favoriteIds
          .map((id) => ListTile(title: Text(id)))
          .toList(),
    );
  },
)
```

**Result:** Changes in Screen A automatically update Screen B! 🎉

---

## ⚠️ Common Issues & Solutions

| Issue | Cause | Fix |
|-------|-------|-----|
| UI not updating | Forgot `notifyListeners()` | Call after every state change |
| "Provider not found" | Provider not at root | Move to `main.dart` above `MaterialApp` |
| Multiple provider instances | Creating new instances | Use `context.read` instead of `new` |
| Performance issues | Too many rebuilds | Use `Consumer` for targeted rebuilds |
| Memory leaks | Storing BuildContext | Never store context in providers |

---

## ✅ Best Practices

| Do ✅ | Don't ❌ |
|-------|----------|
| Use `context.watch` for data display | Store BuildContext in providers |
| Use `context.read` for method calls | Create providers inside widgets |
| Call `notifyListeners()` after changes | Call `notifyListeners()` in getters |
| Keep business logic in providers | Put business logic in widgets |
| Use immutable data when possible | Mutate state without notifying |

---

## 🎨 Real-World Example

```dart
// 1. Create State Class
class AppThemeService extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

// 2. Register at Root
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AppThemeService()),
  ],
  child: Consumer<AppThemeService>(
    builder: (context, themeService, _) {
      return MaterialApp(
        themeMode: themeService.themeMode, // ✨ Reactive!
        // ...
      );
    },
  ),
)

// 3. Use in Widget
IconButton(
  icon: Icon(context.watch<AppThemeService>().isDarkMode 
      ? Icons.light_mode 
      : Icons.dark_mode),
  onPressed: () => context.read<AppThemeService>().toggleTheme(),
)
```

---

## 🎯 Decision Tree

**When to use which method?**

```
Need to rebuild when state changes?
├─ Yes → Use context.watch<T>() or Consumer<T>
└─ No  → Use context.read<T>()

Rebuild entire widget tree?
├─ Yes → Use context.watch<T>()
└─ No  → Use Consumer<T> (more efficient)
```

---

## 📚 Key Files in Farm2Home

| File | Purpose |
|------|---------|
| [cart_service.dart](lib/services/cart_service.dart) | Shopping cart state |
| [favorites_service.dart](lib/services/favorites_service.dart) | User favorites |
| [app_theme_service.dart](lib/services/app_theme_service.dart) | Theme management |
| [provider_demo_screen.dart](lib/screens/provider_demo_screen.dart) | Interactive demo |

---

## 🚀 Quick Commands

```bash
# Install provider
flutter pub add provider

# Run demo
flutter run
# Then navigate to /provider-demo
```

---

## 📖 Learn More

- [Provider Package](https://pub.dev/packages/provider)
- [Flutter State Management Guide](https://docs.flutter.dev/data-and-backend/state-mgmt)
- [Provider Documentation](https://pub.dev/documentation/provider/latest/)

---

**Master Provider, Master Flutter! 🚀**
