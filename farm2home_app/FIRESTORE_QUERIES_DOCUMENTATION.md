# Firestore Queries Demo - Documentation

## Overview

This documentation covers the **Firestore Queries Demo Screen** which demonstrates fundamental database query operations in Cloud Firestore. The implementation showcases `where()` filters, `orderBy()` sorting, and `limit()` pagination patterns.

**File**: `lib/screens/firestore_queries_demo_screen.dart`  
**Route**: `/firestore-queries`

---

## Features Implemented

### 1. **Query Type Selection (where clause)**

The demo allows users to filter data using Firestore's `where()` clause:

```dart
// All Orders - No filter
Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('orders');

// Pending Orders - Equality filter
query = query.where('status', isEqualTo: 'pending');

// Completed Orders - Equality filter
query = query.where('status', isEqualTo: 'completed');
```

**UI Component**: Three button options
- **All Orders** - Retrieves all documents without filtering
- **Status: Pending** - Filters where `status == 'pending'`
- **Status: Completed** - Filters where `status == 'completed'`

### 2. **Dynamic Limit Control**

Implements pagination through `limit()` with an interactive slider:

```dart
query = query.limit(_selectedLimit);  // Limits result set to 1-50 documents
```

**UI Component**: Slider with real-time value display
- Range: 1-50 documents
- Default: 10 documents
- Updates query results in real-time

### 3. **Order By Sorting**

Demonstrates `orderBy()` with ascending and descending options:

```dart
// Newest First (Descending)
query = query.orderBy('createdAt', descending: true);

// Oldest First (Ascending)
query = query.orderBy('createdAt', descending: false);
```

**UI Component**: Radio button group
- **Newest First** - Orders by `createdAt` descending
- **Oldest First** - Orders by `createdAt` ascending

### 4. **Live Query Display**

Shows the actual Firestore query syntax being executed:

```dart
FirebaseFirestore.instance
  .collection('orders')
  .where('status', isEqualTo: 'pending')
  .orderBy('createdAt', descending: true)
  .limit(10)
```

This updates dynamically as users change filter/sort selections.

### 5. **Real-time Results with StreamBuilder**

Implements reactive UI using Firestore snapshots:

```dart
StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
  stream: _buildQuery(),
  builder: (context, snapshot) {
    // Handles loading, error, and data states
  }
)
```

**Features**:
- Real-time updates when data changes
- Loading spinner during data fetch
- Error messages for failed queries
- "No results found" when query returns empty
- Order ID, Status, and Created Date display
- Color-coded status badges

---

## Component Architecture

### State Management

```dart
class _FirestoreQueriesDemoScreenState extends State<FirestoreQueriesDemoScreen> {
  String _selectedQueryType = 'all';      // Filter selection
  int _selectedLimit = 10;                 // Pagination limit
  String _sortOrder = 'descending';        // Sort direction
}
```

### Build Method Structure

1. **AppBar** - "Firestore Queries Demo" with green theme
2. **Query Selector** - Where clause options
3. **Limit Selector** - Pagination slider
4. **Sort Order Selector** - Ascending/Descending radio buttons
5. **Query Info Card** - Live code display
6. **Query Results** - StreamBuilder with result cards

### Key Methods

#### `_buildQuery()` - Query Construction
```dart
Stream<QuerySnapshot<Map<String, dynamic>>> _buildQuery() {
  Query<Map<String, dynamic>> query = 
    FirebaseFirestore.instance.collection('orders');
  
  // Apply filters, ordering, and limits
  // Return stream for real-time updates
}
```

#### `_buildOrderCard()` - Result Display
Renders individual order items with:
- Order ID (with ellipsis for long IDs)
- Status badge with color coding
- Created timestamp
- Status-based styling

#### `_getStatusColor()` - Status Color Mapping
- **Completed** → Green
- **Pending** → Orange
- **Unknown** → Grey

---

## Expected Firestore Collection Structure

The demo expects a Firestore collection named `orders` with documents having:

```json
{
  "id": "order_123",
  "status": "pending" | "completed",
  "createdAt": Timestamp,
  "userId": "user_456",
  // ... other fields
}
```

### Sample Query Results

```json
[
  {
    "id": "order_001",
    "status": "completed",
    "createdAt": "2026-02-05T10:30:00Z",
    "userId": "user_123"
  },
  {
    "id": "order_002",
    "status": "pending",
    "createdAt": "2026-02-04T15:45:00Z",
    "userId": "user_456"
  }
]
```

---

## Firestore Best Practices Demonstrated

### 1. **Query Optimization**
- ✅ Use `where()` to filter before sorting
- ✅ Use `orderBy()` for consistent sorting
- ✅ Use `limit()` for pagination and performance
- ✅ Combine operations in correct order

### 2. **Indexing Requirements**
When combining `where()` and `orderBy()` on different fields, Firestore may require composite indexes:

```
Collection: orders
Where clause: status (Ascending)
Order by: createdAt (Descending)
```

Firestore will prompt to create an index if needed.

### 3. **Real-time Updates**
Using `snapshots()` for real-time data:
```dart
return query.snapshots();  // Updates UI when data changes
```

### 4. **Error Handling**
Implemented at three levels:
- Connection state checking
- Error snapshot handling
- Empty result handling

---

## Integration with App

### Route Registration
In `lib/main.dart`:
```dart
'/firestore-queries': (context) => const FirestoreQueriesDemoScreen(),
```

### Navigation Button
Added to `HomeScreen` demo menu:
```dart
ListTile(
  leading: const Icon(Icons.storage, color: Colors.deepOrange),
  title: const Text('Firestore Queries'),
  subtitle: const Text('where(), orderBy(), limit() patterns'),
  onTap: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/firestore-queries');
  },
)
```

---

## UI/UX Features

### Visual Design
- **Color Scheme**: Green theme matching Farm2Home branding
- **Card-based Layout**: Clear separation of query sections
- **Code Display**: Dark background for syntax visibility
- **Status Badges**: Color-coded for quick status identification

### Interactive Elements
- **Button Group**: Query type selection
- **Slider**: Dynamic limit adjustment (1-50)
- **Radio Buttons**: Sort order selection
- **Stream Updates**: Real-time result refresh

### Responsive Behavior
- Scrollable for long result lists
- Shrink-wrapped ListView in StreamBuilder
- Proper spacing and padding throughout
- Adaptive card sizes

---

## Code Quality

### Error Handling
```dart
if (snapshot.hasError) {
  return Center(
    child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
  );
}
```

### Loading States
```dart
if (snapshot.connectionState == ConnectionState.waiting) {
  return const Center(child: CircularProgressIndicator());
}
```

### Empty State
```dart
if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
  return const Center(child: Text('No results found'));
}
```

### Type Safety
- Explicit `Query<Map<String, dynamic>>` typing
- Proper null checking with `!` operator
- Safe string conversions

---

## Testing Scenarios

### Scenario 1: All Orders
- **Setup**: No filter selected
- **Expected**: All documents in 'orders' collection
- **Limit**: Shows up to selected limit

### Scenario 2: Filter Pending Orders
- **Setup**: Select "Status: Pending"
- **Query**: `where('status', isEqualTo: 'pending')`
- **Expected**: Only pending status documents

### Scenario 3: Pagination with Limit
- **Setup**: Adjust limit slider to 5
- **Expected**: Maximum 5 documents returned
- **Behavior**: Real-time update when limit changes

### Scenario 4: Sort Newest First
- **Setup**: Select "Newest First"
- **Expected**: Documents ordered by `createdAt` descending
- **Result**: Most recent documents appear first

### Scenario 5: Combined Filters
- **Setup**: "Completed" status + "Oldest First" + limit 3
- **Query**: 
  ```
  where('status', isEqualTo: 'completed')
  .orderBy('createdAt', ascending: true)
  .limit(3)
  ```
- **Expected**: 3 oldest completed orders

---

## Future Enhancements

### Potential Additions
1. **Additional Filters**
   - Date range filtering (startDate, endDate)
   - userId filtering for user-specific orders
   - Price range filtering

2. **Advanced Sorting**
   - Multi-field sorting
   - Custom sort order logic

3. **Pagination Controls**
   - Previous/Next page buttons
   - Jump to page functionality
   - Documents per page selector

4. **Data Operations**
   - Edit document from results
   - Delete document from results
   - Batch operations

5. **Query Analytics**
   - Query execution time
   - Results count
   - Data size estimation

6. **Export Features**
   - Export results as CSV
   - Share filtered results
   - Print formatted results

---

## Dependencies

- `cloud_firestore: ^5.0.0`
- `firebase_core: ^3.0.0`
- `flutter: SDK` (Material Design)

---

## Performance Considerations

1. **Index Creation**: Firestore automatically suggests indexes for complex queries
2. **Pagination**: Using `limit()` reduces network transfer and processing
3. **Real-time Subscriptions**: Consider cleanup to prevent memory leaks
4. **Stream Cancellation**: StreamBuilder automatically unsubscribes on widget disposal

---

## Troubleshooting

### Query Returns No Results
- Verify collection name is `orders`
- Check document field names match query predicates
- Ensure documents exist with matching filter criteria

### Index Required Error
- Firestore will provide a clickable link to create index
- Indexes required when combining `where()` on one field and `orderBy()` on another
- Creation typically takes 5-10 minutes

### Real-time Updates Not Working
- Check Firebase permissions in Firestore rules
- Verify user authentication is working
- Ensure StreamBuilder has proper error handling

### Performance Issues
- Reduce limit value to fetch fewer documents
- Add more specific filters to narrow results
- Monitor Firestore usage in Firebase Console

---

## Summary

This Firestore Queries Demo provides an interactive learning environment for understanding:
- ✅ **where() filtering** with equality operators
- ✅ **orderBy() sorting** with ascending/descending options
- ✅ **limit() pagination** with dynamic control
- ✅ **Stream-based real-time updates** with StreamBuilder
- ✅ **Error handling and loading states**
- ✅ **Responsive UI patterns** for data display

The implementation follows Flutter and Firebase best practices while providing a user-friendly interface for experimenting with Firestore query operations.
