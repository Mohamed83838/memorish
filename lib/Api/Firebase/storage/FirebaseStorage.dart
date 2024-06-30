import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class FirestoreStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String?> uploadsignature(Uint8List data, String userId,String filename) async {
    try {

      Reference ref = _storage.ref().child('users/$userId/signatures/$filename');
      UploadTask uploadTask = ref.putData(data);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading photo: $e");
      return null;
    }
  }

  Future<String?> uploadPhoto(File file, String userId) async {
    try {
      String fileName = basename(file.path);
      Reference ref = _storage.ref().child('users/$userId/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading photo: $e");
      return null;
    }
  }


  Future<void> deleteFile(String fileUrl) async {
    try {
      // Extract the path from the URL
      String filePath = Uri.decodeFull(Uri.parse(fileUrl).path); // Decode URL if needed

      // Remove the leading '/'
      if (filePath.startsWith('/')) {
        filePath = filePath.substring(1);
      }

      // Reference to the file
      Reference ref = _storage.ref().child(filePath);

      // Delete the file
      await ref.delete();

      print('File deleted successfully.');
    } catch (e) {
      print('Error deleting file: $e');
      // Handle any errors
    }
  }
}
