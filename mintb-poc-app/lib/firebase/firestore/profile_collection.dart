import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintb_poc_app/preferences/profile_local.dart';

import '../auth.dart';

class ProfileCollection {
  String? id;
  final String nickname;
  final int age;
  final int gender;
  final List<String> images;
  final List<int> languages;

  ProfileCollection(
      this.nickname, this.age, this.gender, this.images, this.languages,
      {this.id});
}

// -- profiles/[uid] : Document
// nickname : string
// age : number
// gender : number

// -- profiles/[uid]/images : Collections
// url : String

// 본인 프로필 조회
Future<ProfileCollection?> fetchProfileDoc() async {
  final profileSnapshot = await FirebaseFirestore.instance
      .collection('profiles')
      .doc("/${getUid()}")
      .get();

  final profileData = profileSnapshot.data();
  if (profileData != null && profileData.isNotEmpty) {
    log(profileData.toString());
    // 언어 목록 변환
    final languages = (profileData["languages"] as List<dynamic>)
        .map((e) => int.parse(e.toString()))
        .toList();

    final imagesSnapshot = await FirebaseFirestore.instance
        .collection('profiles/${getUid()}/images')
        .get();
    // 이미지 목록 변환
    List<String> images = [];
    for (final image in imagesSnapshot.docs) {
      log(image.data().toString());
      images.add(image.data()["url"]);
    }

    return ProfileCollection(profileData["nickname"], profileData["age"],
        profileData["gender"], images, languages);
  }

  return null;
}

// 본인 프로필 생성
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

// 성별 프로필 1건 조회
Future<ProfileCollection?> fetchProfileSingleByGender(int gender,
    {String? currentProfileId}) async {
  log("gender: $gender, current: $currentProfileId");

  final query = FirebaseFirestore.instance
      .collection('profiles')
      .where('gender', isEqualTo: gender)
      .orderBy(FieldPath.documentId)
      .limit(1);

  // 현재 조회된 정보가 있으면
  if (currentProfileId != null) {
    query.startAfter([currentProfileId]);
  }

  // 1건 조회
  final profiles = await query.get();

  if (profiles.docs.isEmpty) {
    return null;
  }

  final profileData = profiles.docs.first.data();
  final profileId = profiles.docs.first.id;
  log(profileData.toString());

  final languages = (profileData["languages"] as List<dynamic>)
      .map((e) => int.parse(e.toString()))
      .toList();

  final imagesSnapshot = await FirebaseFirestore.instance
      .collection('profiles/$profileId/images')
      .get();

  List<String> images = [];
  for (final image in imagesSnapshot.docs) {
    log(image.data().toString());
    images.add(image.data()["url"]);
  }

  return ProfileCollection(profileData["nickname"], profileData["age"],
      profileData["gender"], images, languages,
      id: profileId);
}
