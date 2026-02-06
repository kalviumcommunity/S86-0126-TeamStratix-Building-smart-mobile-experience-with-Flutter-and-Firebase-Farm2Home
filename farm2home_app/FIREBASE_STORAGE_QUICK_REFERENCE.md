# Firebase Storage Media Upload - Quick Reference

## Quick Start

### 1. Pick an Image
```dart
final XFile? image = await _uploadService.pickImage();
```

### 2. Upload to Firebase Storage
```dart
final String downloadUrl = 
  await _uploadService.uploadImage(image);
```

### 3. Display the Image
```dart
Image.network(downloadUrl)
```

---

## Core Methods

### Image Picker
| Method | Returns | Use Case |
|--------|---------|----------|
| `pickImage()` | `XFile?` | Select one image from gallery |
| `pickMultipleImages()` | `List<XFile>` | Select multiple images |

### Upload
| Method | Returns | Use Case |
|--------|---------|----------|
| `uploadImage(XFile)` | `String` (URL) | Upload single image |
| `uploadMultipleImages(List<XFile>)` | `List<String>` | Upload multiple |
| `uploadImageWithProgress(XFile, callback)` | `String` | Upload with progress tracking |

### Delete
| Method | Returns | Use Case |
|--------|---------|----------|
| `deleteImage(downloadUrl)` | `void` | Delete by URL |
| `deleteImageByPath(storagePath)` | `void` | Delete by path |

### Utilities
| Method | Returns | Use Case |
|--------|---------|----------|
| `isValidImageFile(XFile)` | `bool` | Check if image is valid |
| `getFileSizeString(bytes)` | `String` | Format file size (B/KB/MB) |
| `getFileExtension(path)` | `String` | Get file type |
| `createUploadedMediaFromFile(XFile, url)` | `UploadedMedia` | Create media object |

---

## Complete Upload Flow

```dart
// 1. Pick image
final XFile? image = await _uploadService.pickImage();
if (image == null) return;

// 2. Validate
if (!_uploadService.isValidImageFile(image)) {
  showError('Invalid image file');
  return;
}

// 3. Upload with progress
final String url = await _uploadService.uploadImageWithProgress(
  image,
  (progress) => print('${(progress * 100).toInt()}%'),
);

// 4. Create media object
final UploadedMedia media = 
  await _uploadService.createUploadedMediaFromFile(image, url);

// 5. Store and display
uploadedMediaList.add(media);
```

---

## Upload Progress Example

```dart
await _uploadService.uploadImageWithProgress(
  imageFile,
  (progress) {
    setState(() {
      uploadProgress = progress;  // 0.0 to 1.0
    });
  },
);

// UI
LinearProgressIndicator(
  value: uploadProgress,
)

// Display percentage
Text('${(uploadProgress * 100).toInt()}%')
```

---

## Error Handling

```dart
try {
  final url = await _uploadService.uploadImage(image);
} on FirebaseException catch (e) {
  print('Firebase error: ${e.code}');
} catch (e) {
  print('Error: $e');
}
```

---

## Firebase Storage Structure

After upload, file appears in Firebase Console:
```
Storage
└── images/
    └── 1707242400000_photo.jpg
```

Path format: `images/{timestamp}_{filename}`

---

## File Size Limits & Optimization

| Setting | Value | Purpose |
|---------|-------|---------|
| Image Quality | 85% | Reduce file size |
| Max Width | 1080px | Limit dimensions |
| Max Height | 1920px | Limit dimensions |
| Max Upload | 5MB | Firebase rule limit |

---

## UploadedMedia Model

```dart
class UploadedMedia {
  final String fileName;           // "photo.jpg"
  final String downloadUrl;        // Firebase public URL
  final DateTime uploadedAt;       // When uploaded
  final String fileSize;           // "2.50 MB"
  final String fileType;           // "JPG"
}
```

---

## Common Operations

### Display Image from URL
```dart
Image.network(
  downloadUrl,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
)
```

### Copy Download URL
```dart
Clipboard.setData(ClipboardData(text: downloadUrl));
```

### Delete Image
```dart
await _uploadService.deleteImage(downloadUrl);
uploadedMediaList.removeWhere(
  (media) => media.downloadUrl == downloadUrl
);
```

### Get File Size
```dart
final int bytes = await File(imageFile.path).length();
final String sizeStr = _uploadService.getFileSizeString(bytes);
```

---

## UI Pattern - Media Gallery

```dart
ListView.builder(
  itemCount: uploadedMediaList.length,
  itemBuilder: (context, index) {
    final media = uploadedMediaList[index];
    return Card(
      child: Column(
        children: [
          Image.network(media.downloadUrl, height: 200),
          ListTile(
            title: Text(media.fileName),
            subtitle: Text('${media.fileSize} • ${media.fileType}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => deleteImage(media),
            ),
          ),
        ],
      ),
    );
  },
)
```

---

## Validation

```dart
// Check if valid image
if (!_uploadService.isValidImageFile(image)) {
  print('Invalid file type');
}

// Valid extensions: jpg, jpeg, png, gif, webp

// File size check (before upload)
final size = await File(image.path).length();
if (size > 5 * 1024 * 1024) {
  print('File too large (max 5MB)');
}
```

---

## Permissions Required

### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS (ios/Runner/Info.plist)
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos to upload images</string>
```

---

## Firebase Storage Rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /images/{allPaths=**} {
      // Read: authenticated users only
      allow read: if request.auth != null;
      
      // Write: authenticated users, max 5MB
      allow write: if request.auth != null 
        && request.resource.size < 5 * 1024 * 1024;
      
      // Delete: authenticated users
      allow delete: if request.auth != null;
    }
  }
}
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "Permission denied" | Check Firebase Storage rules, user must be authenticated |
| Image doesn't load | Verify download URL is correct in Firebase Console |
| "Invalid File" error | Check file extension is jpg/png/gif/webp |
| Upload stuck | Check network connection, file size < 5MB |
| Progress doesn't show | Progress only visible for larger files (> 1MB) |

---

## Performance Tips

1. **Compress Images**: Set `imageQuality: 85` in picker
2. **Limit Dimensions**: Use `maxWidth` and `maxHeight`
3. **Show Progress**: Use `uploadImageWithProgress()` for large files
4. **Batch Uploads**: Use `uploadMultipleImages()` for efficiency
5. **Cache Images**: Use `Image.network()` with caching headers

---

## Integration Checklist

- [ ] Added `firebase_storage: ^12.0.0` to pubspec.yaml
- [ ] Added `image_picker: ^1.0.0` to pubspec.yaml
- [ ] Created `MediaUploadService` with upload logic
- [ ] Created `MediaUploadScreen` with UI
- [ ] Added `/media-upload` route to main.dart
- [ ] Added navigation button to HomeScreen
- [ ] Tested image picker
- [ ] Tested upload functionality
- [ ] Verified files appear in Firebase Console
- [ ] Set Firebase Storage rules for security

---

## Resources

📚 **Files**:
- `lib/services/media_upload_service.dart` - Upload service
- `lib/screens/media_upload_screen.dart` - UI screen
- `FIREBASE_STORAGE_DOCUMENTATION.md` - Full documentation

🔗 **Firebase Docs**:
- [Firebase Storage](https://firebase.google.com/docs/storage)
- [Image Picker Package](https://pub.dev/packages/image_picker)

---

## Summary

Quick workflow for media upload:
1. **Pick** → Select image from gallery
2. **Validate** → Check file type
3. **Upload** → Send to Firebase Storage
4. **Retrieve** → Get download URL
5. **Display** → Show in gallery UI
6. **Manage** → Delete if needed

Perfect for apps with media features! 🚀
