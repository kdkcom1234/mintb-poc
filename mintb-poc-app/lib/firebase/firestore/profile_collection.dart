import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintb_poc_app/preferences/profile_local.dart';

import '../auth.dart';

class ProfileCollection {
  final String nickname;
  final int age;
  final int gender;
  final List<String> images;

  ProfileCollection(
    this.nickname,
    this.age,
    this.gender,
    this.images,
  );
}

// -- profiles/[uid] : Document
// nickname : string
// age : number
// gender : number

// -- profiles/[uid]/images : Collections
// url : String

Future<ProfileCollection?> fetchProfileDoc() async {
  final profileSnapshot = await FirebaseFirestore.instance
      .collection('profiles')
      .doc("/${getUid()}")
      .get();

  final profileData = profileSnapshot.data();
  if (profileData != null && profileData.isNotEmpty) {
    final imagesSnapshot = await FirebaseFirestore.instance
        .collection('profiles/${getUid()}/images')
        .get();

    log(profileData.toString());

    List<String> images = [];
    for (final image in imagesSnapshot.docs) {
      log(image.data().toString());
      images.add(image.data()["url"]);
    }

    return ProfileCollection(profileData["nickname"], profileData["age"],
        profileData["gender"], images);
  }

  return null;
}

Future<void> createProfile(ProfileLocal profileLocal) async {
  final profileDocRef =
      FirebaseFirestore.instance.collection('profiles').doc("/${getUid()}");

  final imagesRef =
      FirebaseFirestore.instance.collection('profiles/${getUid()}/images');

  // 프로필 저장
  final profileData = profileLocal.toJson();
  profileData.remove("images");

  await profileDocRef.set(profileData);

  // 이미지 저장
  for (final imageUrl in profileLocal.images) {
    await imagesRef.add({"url": imageUrl});
  }
}
