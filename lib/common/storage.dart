import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;

final storageRef = FirebaseStorage.instance.ref();

void deleteImage(String location) async {
  storageRef.child(location).delete();
}

Future<String> uploadImage(File file, {String? location}) async {
  var path = location ?? 'images/${DateTime.now().millisecondsSinceEpoch}.png';
// Create the file metadata
  final metadata = SettableMetadata(contentType: "image/png");

// Upload file and metadata to the path 'images/mountains.jpg'
  await resizeImage(file).then((value) async {
    await storageRef
        .child(path)
        .putFile(value, metadata);
  });

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

Future<File> resizeImage(File imageFile) async {
  final rawBytes = await imageFile.readAsBytes();
  final decodedImage = img.decodeImage(rawBytes);

  if (decodedImage != null) {
    final resizedImage = img.copyResize(decodedImage, width: 200);
    final resizedBytes = img.encodeJpg(resizedImage, quality: 100);
    final resizedFile = File(imageFile.path)..writeAsBytesSync(resizedBytes);

    return resizedFile;
  } else {
    return imageFile;
  }
}

String getDownloadUrl(String path) {
  String url = 'https://firebasestorage.googleapis.com/v0/b/taph-be110.appspot.com/o/${path.replaceAll("/", "%2F")}?alt=media';
  return url;
}
