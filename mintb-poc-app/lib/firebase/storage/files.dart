import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

final storage = FirebaseStorage.instance;

Future<String> uploadFile(File file) async {
  // Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  final ext = _getExtension(file);

  final fileRef = storageRef.child("${const Uuid().v4()}.$ext");
  await fileRef.putFile(file);

  final url = await fileRef.getDownloadURL();

  return url;
}

String _getExtension(File file) {
  var fileName = file.uri.pathSegments.last;
  var dotIndex = fileName.lastIndexOf('.');

  if (dotIndex == -1 || dotIndex == fileName.length - 1) {
    // 확장자가 없거나 파일이 .으로 끝나는 경우
    return '';
  }

  return fileName.substring(dotIndex + 1);
}
