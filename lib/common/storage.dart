import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final storageRef = FirebaseStorage.instance.ref();

Future<String> uploadImage(File file, {String? location}) async {
  var path = location ?? 'images/${DateTime.now().millisecondsSinceEpoch}.png';
// Create the file metadata
  final metadata = SettableMetadata(contentType: "image/png");

// Upload file and metadata to the path 'images/mountains.jpg'
  await storageRef
      .child(path)
      .putFile(file, metadata);

  return path;

// Listen for state changes, errors, and completion of the upload.
//   uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
//     switch (taskSnapshot.state) {
//       case TaskState.running:
//         final progress =
//             100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
//         print("Upload is $progress% complete.");
//         break;
//       case TaskState.paused:
//         print("Upload is paused.");
//         break;
//       case TaskState.canceled:
//         print("Upload was canceled");
//         break;
//       case TaskState.error:
//       // Handle unsuccessful uploads
//         break;
//       case TaskState.success:
//       // Handle successful uploads on complete
//       // ...
//         break;
//     }
//   }
//   );
}

String getDownloadUrl(String path) {
  String url = 'https://firebasestorage.googleapis.com/v0/b/taph-be110.appspot.com/o/${path.replaceAll("/", "%2F")}?alt=media';
  return url;
}
