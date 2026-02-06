# My Notes CRUD Implementation Guide

## Overview

This document explains the complete CRUD (Create, Read, Update, Delete) workflow for the "My Notes" feature in the Farm2Home app. Each user can manage their own personal notes stored securely in Firestore.

## Architecture

### Data Structure
```
/users/{uid}
  /items/{itemId}
    - id: string (Note ID)
    - title: string (Note title)
    - content: string (Note content)
    - createdAt: timestamp (Creation timestamp)
    - updatedAt: timestamp (Last update timestamp)
    - uid: string (User ID who owns the note)
```

### Technology Stack
- **Frontend**: Flutter
- **Authentication**: Firebase Authentication (Email/Password)
- **Database**: Cloud Firestore
- **Real-time Updates**: Firestore StreamBuilder
- **Architecture Pattern**: Service Layer + UI Layer

## Files Structure

### Models
- **`lib/models/note.dart`**: Note data model with serialization/deserialization

### Services
- **`lib/services/notes_service.dart`**: CRUD operations service
  - `createNote()`: Create new note
  - `getUserNotesStream()`: Read notes with real-time updates
  - `getNote()`: Get single note
  - `updateNote()`: Update existing note
  - `deleteNote()`: Delete note
  - `getNoteCount()`: Get total notes count

### UI
- **`lib/screens/my_notes_screen.dart`**: Main UI screen with all CRUD operations

### Security
- **`firestore.rules`**: Firestore security rules
- **`FIRESTORE_RULES_MY_NOTES.md`**: Security rules documentation

## CRUD Operations

### 1. CREATE - Add New Note

**File**: `lib/services/notes_service.dart` - `createNote()` method

**Database Path**: `/users/{uid}/items/{itemId}`

**Code Flow**:
```dart
// 1. Validate user authentication
if (uid.isEmpty) throw 'User not authenticated';

// 2. Create Note object
final note = Note(
  title: title,
  content: content,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  uid: uid,
);

// 3. Store in Firestore
final docRef = await _firestore
    .collection('users')
    .doc(uid)
    .collection('items')
    .add(note.toJson());

// 4. Return generated document ID
return docRef.id;
```

**UI Implementation** (`my_notes_screen.dart`):
```dart
// User taps "+" button → _showCreateNoteDialog()
// Dialog shows title & content text fields
// User enters data and clicks "Create"
// Service.createNote() is called
// Real-time stream updates the list automatically
```

**User Actions**:
1. Click "+" button on MyNotesScreen
2. Enter title and content
3. Click "Create"
4. Note appears in the list immediately (real-time)

---

### 2. READ - Retrieve Notes

**File**: `lib/services/notes_service.dart` - `getUserNotesStream()` method

**Database Path**: `/users/{uid}/items/**`

**Real-time Updates with StreamBuilder**:
```dart
// In Service Layer
Stream<List<Note>> getUserNotesStream(String uid) {
  return _firestore
      .collection('users')
      .doc(uid)
      .collection('items')
      .orderBy('updatedAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Note.fromFirestore(doc))
          .toList());
}

// In UI Layer
StreamBuilder<List<Note>>(
  stream: _notesService.getUserNotesStream(uid),
  builder: (context, snapshot) {
    // Handle loading, error, and data states
    final notes = snapshot.data ?? [];
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(notes[index]);
      },
    );
  },
)
```

**Key Features**:
- **Real-time Sync**: Firestore StreamBuilder automatically updates UI
- **Ordered**: Notes ordered by most recently updated
- **User-Scoped**: Only user's own notes are fetched
- **Live Collaboration**: If user has notes open in multiple devices, changes sync instantly

**User Actions**:
1. User navigates to `/my-notes` route
2. UI automatically loads user's notes
3. Notes display in descending order by update time
4. Any changes made by other devices appear instantly

---

### 3. UPDATE - Edit Existing Note

**File**: `lib/services/notes_service.dart` - `updateNote()` method

**Database Path**: `/users/{uid}/items/{itemId}`

**Code Flow**:
```dart
Future<void> updateNote({
  required String uid,
  required String noteId,
  required String title,
  required String content,
}) async {
  // 1. Validate IDs
  if (uid.isEmpty || noteId.isEmpty) {
    throw 'Invalid user ID or note ID';
  }

  // 2. Update in Firestore
  await _firestore
      .collection('users')
      .doc(uid)
      .collection('items')
      .doc(noteId)
      .update({
        'title': title.trim(),
        'content': content.trim(),
        'updatedAt': FieldValue.serverTimestamp(), // Server time for sync
      });
}
```

**UI Implementation**:
```dart
// User clicks edit icon on note card → _showEditNoteDialog()
// Dialog prefills with current note data
// User modifies title/content
// Clicks "Update"
// Service.updateNote() called
// Firestore updates document
// Real-time stream triggers rebuild with new data
```

**User Actions**:
1. Click edit icon on note card
2. Dialog opens with current note data
3. Edit title/content
4. Click "Update"
5. List immediately reflects changes

---

### 4. DELETE - Remove Note

**File**: `lib/services/notes_service.dart` - `deleteNote()` method

**Database Path**: `/users/{uid}/items/{itemId}`

**Code Flow**:
```dart
Future<void> deleteNote(String uid, String noteId) async {
  // 1. Validate IDs
  if (uid.isEmpty || noteId.isEmpty) {
    throw 'Invalid user ID or note ID';
  }

  // 2. Delete from Firestore
  await _firestore
      .collection('users')
      .doc(uid)
      .collection('items')
      .doc(noteId)
      .delete();
  
  // Real-time stream automatically removes from UI
}
```

**UI Implementation**:
```dart
// User clicks delete icon → _showDeleteConfirmDialog()
// Confirmation dialog appears
// User confirms
// Service.deleteNote() called
// Firestore deletes document
// Real-time stream triggers rebuild without deleted note
```

**User Actions**:
1. Click delete icon
2. Confirmation dialog appears
3. Click "Delete"
4. Note disappears from list immediately

---

## Security Model (Firestore Rules)

### Rule Implementation
```firestore
match /users/{uid}/items/{itemId} {
  // Read: User can only read their own items
  allow read: if request.auth.uid == uid;
  
  // Create: User authenticated and uid matches
  allow create: if 
    request.auth.uid == uid &&
    request.resource.data.uid == uid;
  
  // Update: User can only update their own
  allow update: if request.auth.uid == uid;
  
  // Delete: User can only delete their own
  allow delete: if request.auth.uid == uid;
}
```

### How It Works
1. **User A** (uid: `user_a`) creates a note
   - Stored at: `/users/user_a/items/note_123`
   - Only User A can access

2. **User B** (uid: `user_b`) tries to read User A's note
   - Firestore checks: `request.auth.uid == uid`
   - `user_b != user_a` → Permission Denied
   - User B only sees: `/users/user_b/items/**`

---

## Testing CRUD Operations

### Prerequisites
- Flutter app running
- Firebase project configured
- `firestore.rules` deployed to Firebase Console
- Test user accounts created

### Test Scenarios

#### Test 1: Create & Read
```
1. Sign in as User A
2. Navigate to My Notes
3. Click "+" button
4. Enter title: "Test Note"
5. Enter content: "This is a test"
6. Click "Create"
✓ Note appears in list immediately
✓ Timestamp shows correct time
```

#### Test 2: Real-time Sync
```
1. Sign in as User A on Device 1
2. Open My Notes
3. Sign in as User A on Device 2 (or browser)
4. Open My Notes
5. On Device 1, create new note
✓ Note appears on Device 2 in < 1 second
```

#### Test 3: Update
```
1. Create a note with title "Original"
2. Click edit icon
3. Change title to "Updated"
4. Click "Update"
✓ List shows updated title immediately
✓ Updated timestamp changed
```

#### Test 4: Delete
```
1. Create a note
2. Note appears in list
3. Click delete icon
4. Confirm deletion
✓ Note removed from list immediately
✓ No trace of deleted note
```

#### Test 5: User Isolation
```
1. Sign in as User A
2. Create note "User A Note"
3. Sign out
4. Sign in as User B
5. Open My Notes
✓ User B's list is empty or contains only their notes
✓ User A's notes NOT visible to User B
```

#### Test 6: Firestore Rules Enforcement
```
1. Go to Firebase Console → Firestore
2. Browse Collections
3. Navigate to /users/user_a/items/
4. Try to manually access from user_b profile
✓ Access denied
✓ Security rules working
```

---

## Complete User Flow

### First Time User
```
1. Opens app
2. Not authenticated
3. Redirected to login screen
4. Signs up with email/password
5. Authenticated
6. Can navigate to My Notes
7. Starts creating notes
```

### Returning User
```
1. Opens app
2. Firebase checks auth state
3. User already authenticated
4. Lands on home screen
5. Navigates to My Notes
6. All previous notes loaded
7. Can create/edit/delete
```

### Full CRUD Session
```
SESSION: User A - Device 1
1. Sign In ✓
2. Navigate to My Notes ✓
3. See empty list ✓
4. Create Note 1 "Shopping" with content "Buy milk" ✓
5. Create Note 2 "Tasks" with content "Finish project" ✓
6. See 2 notes in list ✓
7. Click Edit on Note 1
8. Change to "Buy milk & eggs" ✓
9. Note updates instantly ✓
10. Click Delete on Note 2
11. Confirm deletion ✓
12. Note 2 removed, only Note 1 remains ✓
13. Sign Out ✓

VERIFY ISOLATION:
14. Sign In as User B ✓
15. Navigate to My Notes ✓
16. See empty list (User B has no notes) ✓
17. Cannot see User A's notes ✓
```

---

## Integration Points

### With Authentication
- Uses `FirebaseAuth.instance.currentUser.uid`
- Only authenticated users can create/edit/delete
- Unauthenticated users redirected to login

### With Firestore
- Document structure: user segregation
- Real-time updates via StreamBuilder
- Server-side timestamps for consistency
- Security rules enforce user isolation

### With Navigation
- Route: `/my-notes`
- Added to main.dart routes
- Requires authentication (checked at app level)

---

## Performance Considerations

### Optimization Techniques
1. **Indexing**: Firestore creates indexes automatically for ordered queries
2. **Pagination**: Can be added for users with many notes
3. **Caching**: StreamBuilder caches data efficiently
4. **Query Efficiency**: Each user queries only their own documents

### Firestore Usage
- **Reads**: 1 initial load + 1 per real-time update
- **Writes**: 1 per create/update/delete operation
- **Deletes**: 1 per delete operation

---

## Deployment Checklist

- [ ] Test all CRUD operations locally
- [ ] Test with multiple user accounts
- [ ] Verify security rules in Firebase Console
- [ ] Deploy firestore.rules to Firebase
- [ ] Test user isolation
- [ ] Create and merge PR to main branch
- [ ] Record video demo
- [ ] Share Google Drive link (edit access for all)
- [ ] Submit PR and video links

---

## Troubleshooting

### Issue: Notes not appearing
**Solution**: 
- Check user is authenticated
- Verify Firestore rules are deployed
- Check collection path: `/users/{uid}/items/`

### Issue: Delete not working
**Solution**:
- Verify user UID matches
- Check Firestore rules allow delete
- Ensure document exists before deleting

### Issue: Real-time updates not syncing
**Solution**:
- Check internet connection
- Verify StreamBuilder subscription is active
- Check Firestore listener limits

---

## References

- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Firestore Real-time Updates](https://firebase.google.com/docs/firestore/query-data/listen)
- [Flutter StreamBuilder](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html)
- [Firebase Auth State](https://firebase.google.com/docs/auth/flutter/start)
