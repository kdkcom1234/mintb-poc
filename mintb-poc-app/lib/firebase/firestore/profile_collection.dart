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
Future<List<ProfileCollection>> fetchProfilesPairByGender(int gender,
    {String? currentProfileId}) async {
  log("gender: $gender, current: $currentProfileId");

  // 첫 페이지에만 2개를 로딩한다.
  // 2번째 페이지부터는 다음 페이지만 로딩한다.
  var query = FirebaseFirestore.instance
      .collection('profiles')
      .where('gender', isEqualTo: gender)
      .orderBy(FieldPath.documentId)
      .limit(currentProfileId == null ? 2 : 1);

  // 현재 조회된 정보가 있으면
  if (currentProfileId != null) {
    log("query after: $currentProfileId");
    query = query.startAfter([currentProfileId]);
  }

  // 1건 조회
  final profiles = await query.get();

  if (profiles.docs.isEmpty) {
    return [];
  }

  List<ProfileCollection> list = [];
  for (final doc in profiles.docs) {
    final profileData = doc.data();
    final profileId = doc.id;
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

    list.add(ProfileCollection(profileData["nickname"], profileData["age"],
        profileData["gender"], images, languages,
        id: profileId));
  }

  return list;
}
