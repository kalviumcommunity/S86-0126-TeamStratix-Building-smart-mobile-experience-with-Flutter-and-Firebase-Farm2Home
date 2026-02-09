# Firestore Queries - Quick Reference

## Demo Location
📱 **Route**: `/firestore-queries`  
🗂️ **File**: `lib/screens/firestore_queries_demo_screen.dart`  
🏠 **Navigation**: HomeScreen → Demos → Firestore Queries

---

## Query Operations at a Glance

### WHERE Clause (Filtering)

| Operation | Code | Example |
|-----------|------|---------|
| **Equality** | `.where('field', isEqualTo: value)` | `.where('status', isEqualTo: 'pending')` |
| **Greater Than** | `.where('field', isGreaterThan: value)` | `.where('price', isGreaterThan: 100)` |
| **Less Than** | `.where('field', isLessThan: value)` | `.where('quantity', isLessThan: 5)` |
| **Array Contains** | `.where('field', arrayContains: value)` | `.where('tags', arrayContains: 'organic')` |
| **In Query** | `.where('field', whereIn: [values])` | `.where('status', whereIn: ['pending', 'processing'])` |

**In Demo**: All, Pending, Completed

---

### ORDER BY Clause (Sorting)

| Direction | Code | Result |
|-----------|------|--------|
| **Ascending** | `.orderBy('field')` | Oldest to Newest (A→Z, 0→9) |
| **Descending** | `.orderBy('field', descending: true)` | Newest to Oldest (Z→A, 9→0) |

**In Demo**: Newest First (Descending), Oldest First (Ascending)

---

### LIMIT Clause (Pagination)

| Operation | Code | Example |
|-----------|------|---------|
| **Limit** | `.limit(n)` | `.limit(10)` returns max 10 docs |

**In Demo**: Interactive slider 1-50 documents

---

## Complete Query Examples

### Example 1: Pending Orders (Newest First)
```dart
FirebaseFirestore.instance
  .collection('orders')
  .where('status', isEqualTo: 'pending')
  .orderBy('createdAt', descending: true)
  .limit(10)
  .snapshots()  // For real-time updates
```

### Example 2: Completed Orders (Oldest First, Limited)
```dart
FirebaseFirestore.instance
  .collection('orders')
  .where('status', isEqualTo: 'completed')
  .orderBy('createdAt', descending: false)
  .limit(5)
  .snapshots()
```

### Example 3: All Orders with Pagination
```dart
FirebaseFirestore.instance
  .collection('orders')
  .orderBy('createdAt', descending: true)
  .limit(20)
  .snapshots()
```

---

## UI Controls

### 1. Query Type Selector
```
┌─────────────────────────────────┐
│ Query Type (where clause)       │
├─────────────────────────────────┤
│ [All Orders] [Pending] [Done]   │
└─────────────────────────────────┘
```
**Effect**: Changes `where()` clause filter

### 2. Limit Slider
```
┌─────────────────────────────────┐
│ Limit Results                   │
├─────────────────────────────────┤
│ ◀─────●──────────────────────▶  │
│     10 items                    │
└─────────────────────────────────┘
```
**Effect**: Changes `limit()` value (1-50)

### 3. Sort Order
```
┌─────────────────────────────────┐
│ Order By (createdAt)            │
├─────────────────────────────────┤
│ ◉ Newest First                  │
│ ○ Oldest First                  │
└─────────────────────────────────┘
```
**Effect**: Changes `descending` boolean

---

## Real-time Updates with StreamBuilder

```dart
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: _buildQuery(),
  builder: (context, snapshot) {
    // Automatically rebuilds when data changes
  }
)
```

**Handling States**:
- ⏳ **Loading**: Shows CircularProgressIndicator
- ❌ **Error**: Displays error message in red
- ✅ **Data**: Shows list of order cards
- 🔄 **Real-time**: Rebuilds when Firestore data changes

---

## Response Data Structure

```json
{
  "id": "doc_id_123",
  "status": "pending",
  "createdAt": Timestamp(2026-02-05),
  "userId": "user_456"
}
```

**Display Components**:
- Order ID (document path)
- Status with color badge
- Created timestamp
- Status-based styling

---

## Firestore Best Practices

✅ **DO:**
- Filter with `where()` before `orderBy()`
- Use `limit()` for pagination
- Create indexes for complex queries
- Use `snapshots()` for real-time data

❌ **DON'T:**
- Order by fields without indexes
- Fetch all documents then filter
- Create new queries unnecessarily
- Ignore Firestore index suggestions

---

## Common Queries

| Use Case | Query |
|----------|-------|
| Get my orders | `.where('userId', isEqualTo: uid)` |
| Recent orders | `.orderBy('createdAt', descending: true)` |
| Pending count | `.where('status', isEqualTo: 'pending').limit(100)` |
| Expensive items | `.where('price', isGreaterThan: 1000)` |
| By category | `.where('category', isEqualTo: 'produce')` |

---

## Keyboard Shortcuts & Tips

| Action | Result |
|--------|--------|
| Tap query button | Updates filter instantly |
| Drag limit slider | Real-time query refresh |
| Toggle sort radio | Reorders results |
| Scroll results | View more order items |

---

## Integration Code

### Adding to Your App
```dart
// In main.dart routes
'/firestore-queries': (context) => const FirestoreQueriesDemoScreen(),

// Import at top
import 'screens/firestore_queries_demo_screen.dart';
```

### Navigation from Other Screen
```dart
Navigator.pushNamed(context, '/firestore-queries');
```

---

## Troubleshooting Quick Tips

| Issue | Solution |
|-------|----------|
| No results show | Check collection name and field names |
| "Index required" error | Click link in error to create index (takes 5-10 min) |
| Results not updating | Check Firebase auth and Firestore rules |
| Slow performance | Reduce limit, add more filters |

---

## Resources

📚 **Documentation Files**:
- `FIRESTORE_QUERIES_DOCUMENTATION.md` - Full technical guide
- `FIRESTORE_QUERIES_QUICK_REFERENCE.md` - This file

🔗 **Firebase Docs**:
- [Cloud Firestore Queries](https://firebase.google.com/docs/firestore/query-data/queries)
- [Firestore Indexes](https://firebase.google.com/docs/firestore/query-data/index-overview)

---

## Summary

This demo screen teaches Firestore query fundamentals:
- **WHERE**: Filter documents by field values
- **ORDER BY**: Sort results ascending/descending  
- **LIMIT**: Control result set size
- **STREAMS**: Get real-time updates

Perfect for learning database patterns! 🚀
