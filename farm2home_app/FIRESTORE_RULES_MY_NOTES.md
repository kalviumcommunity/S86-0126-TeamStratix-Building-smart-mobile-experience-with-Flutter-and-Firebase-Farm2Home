# Firestore Security Rules for My Notes CRUD Feature

This document describes the Firestore security rules required for the My Notes feature to work securely.

## Rule Schema

The My Notes feature uses the following Firestore collection structure:

```
/users/{uid}
  /items/{itemId}
    - id: string
    - title: string
    - content: string
    - createdAt: timestamp
    - updatedAt: timestamp
    - uid: string
```

## Firestore Rules

```firestore
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // Allow users to manage their own user document
    match /users/{uid} {
      // Users can read their own user document
      allow read: if request.auth.uid == uid;
      // Users can create and update their own user document
      allow create, update: if request.auth.uid == uid;
      // Users can delete their own user document
      allow delete: if request.auth.uid == uid;
      
      // Allow CRUD operations on items (notes) collection
      // Path: /users/{uid}/items/{itemId}
      match /items/{itemId} {
        // Users can only read their own items
        allow read: if request.auth.uid == uid;
        
        // Users can create new items (notes)
        allow create: if 
          request.auth.uid == uid &&
          request.resource.data.uid == uid;
        
        // Users can only update their own items
        allow update: if request.auth.uid == uid;
        
        // Users can only delete their own items
        allow delete: if request.auth.uid == uid;
      }
    }
  }
}
```

## How It Works

### Authentication Check
- `request.auth.uid == uid` ensures the user can only access their own data
- `request.auth` contains the authenticated user's information

### CRUD Operations

1. **Create (Allow create)**
   - User must be authenticated (`request.auth.uid`)
   - User must be accessing their own user document (`request.auth.uid == uid`)
   - The note's `uid` field must match the authenticated user's ID

2. **Read (Allow read)**
   - User must be authenticated
   - User can only read notes from their own `/users/{uid}/items` collection

3. **Update (Allow update)**
   - User must be authenticated
   - User must be updating their own notes

4. **Delete (Allow delete)**
   - User must be authenticated
   - User must be deleting their own notes

## Implementation in App

The NotesService class implements CRUD operations that work with these rules:

- **createNote()**: Adds a note to `/users/{uid}/items/{itemId}`
- **getUserNotesStream()**: Reads notes as a Stream for real-time updates
- **updateNote()**: Updates a specific note for the user
- **deleteNote()**: Deletes a specific note for the user

## Testing the Rules

To verify these rules are working:

1. Sign in as User A and create a note
2. Note gets stored at `/users/{uidA}/items/{noteId}`
3. Sign out
4. Sign in as User B
5. User B should NOT be able to read, modify, or delete User A's notes
6. User B can only see their own notes at `/users/{uidB}/items/**`

## Deploy Rules

To deploy these rules to your Firebase project:

### Option 1: Firebase Console
1. Go to Firebase Console → Your Project
2. Navigate to Firestore Database → Rules
3. Copy the rules above
4. Click "Publish"

### Option 2: Firebase CLI
```bash
firebase login
firebase use <project-id>
firebase deploy --only firestore:rules
```

## Benefits of User-Scoped Data

1. **Security**: Each user can only see and modify their own data
2. **Privacy**: No cross-user data leakage
3. **Performance**: Queries are optimized to specific user branches
4. **Compliance**: Meets data protection and privacy regulations
