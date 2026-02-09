# CRUD Quick Reference ⚡

## 🚀 Quick Setup

### 1. Navigate to CRUD Screen
```dart
import 'package:farm2home_app/screens/crud_demo_screen.dart';

Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const CrudDemoScreen()),
);
```

### 2. Ensure User is Logged In
CRUD operations require authentication!

---

## 📝 CRUD Operations at a Glance

| Operation | Action | Method |
|-----------|--------|--------|
| **CREATE** | Tap + button | `createItem(title, description)` |
| **READ** | Auto-display in list | `getUserItemsStream()` |
| **UPDATE** | Tap edit icon | `updateItem(id, title, description)` |
| **DELETE** | Tap delete icon | `deleteItem(id)` |

---

## 💻 Code Snippets

### CREATE
```dart
await _crudService.createItem(
  title: 'My Note',
  description: 'Note content here',
);
```

### READ (Real-time)
```dart
StreamBuilder<List<NoteItem>>(
  stream: _crudService.getUserItemsStream(),
  builder: (context, snapshot) {
    final items = snapshot.data ?? [];
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(items[i].title),
      ),
    );
  },
)
```

### UPDATE
```dart
await _crudService.updateItem(
  itemId: item.id!,
  title: 'Updated Title',
  description: 'Updated content',
);
```

### DELETE
```dart
await _crudService.deleteItem(item.id!);
```

---

## 🔒 Firestore Rules (Copy-Paste)

```javascript
match /users/{userId}/items/{itemId} {
  allow read: if request.auth != null && request.auth.uid == userId;
  allow create: if request.auth != null && request.auth.uid == userId;
  allow update: if request.auth != null && request.auth.uid == userId;
  allow delete: if request.auth != null && request.auth.uid == userId;
}
```

---

## 🎨 UI Features

### Screen Components
- ✅ Real-time list of items
- ✅ Create dialog with form validation
- ✅ Edit dialog with pre-filled data
- ✅ Delete confirmation dialog
- ✅ Empty state placeholder
- ✅ Loading indicators
- ✅ Error handling
- ✅ Success/error messages

### User Actions
1. **Add Note**: Tap + button → Fill form → Tap Create
2. **View Notes**: Automatically displayed in list
3. **Edit Note**: Tap edit icon → Modify → Tap Update
4. **Delete Note**: Tap delete icon → Confirm

---

## 🏗️ Data Structure

```
/users/{userId}/items/{itemId}
{
  "title": string,
  "description": string,
  "createdAt": Timestamp,
  "updatedAt": Timestamp?,
  "userId": string
}
```

---

## 🧪 Test Checklist

- [ ] Create new note works
- [ ] Notes display in list
- [ ] Edit note updates correctly
- [ ] Delete note removes item
- [ ] Real-time sync works (test on 2 devices)
- [ ] Validation prevents empty fields
- [ ] Only see your own notes (test with 2 accounts)

---

## ⚠️ Common Errors

| Error | Fix |
|-------|-----|
| `permission-denied` | Update Firestore rules |
| `User not authenticated` | Login before CRUD |
| `Document not found` | Check if item ID is correct |
| UI not updating | Use StreamBuilder, not FutureBuilder |

---

## 🎯 Key Files

| File | Purpose |
|------|---------|
| [note_item.dart](lib/models/note_item.dart) | Data  model |
| [crud_service.dart](lib/services/crud_service.dart) | CRUD operations |
| [crud_demo_screen.dart](lib/screens/crud_demo_screen.dart) | UI screen |
| [firestore_rules_with_crud.rules](firestore_rules_with_crud.rules) | Security rules |

---

## 📚 Full Documentation

For complete guide, see [CRUD_IMPLEMENTATION_GUIDE.md](CRUD_IMPLEMENTATION_GUIDE.md)

---

## 🚀 Quick Commands

```bash
# Run app
flutter run

# Deploy Firestore rules
firebase deploy --only firestore:rules
```

---

**Ready to CRUD! 📝✨**
