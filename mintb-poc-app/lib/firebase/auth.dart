import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../env.dart';

// android sha1 키 생성(debug용)
// keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

// 디지털지문: 3A:69:E4:E4:95:CC:8C:B7:6C:C0:58:3F:EF:7D:D1:7D:96:13:A3:2B

// 프로젝트 안드로이드 앱에 디지털 지문 추가
// google-service.json 파일을 다시 받고 덮어 씌우기

Future<UserCredential?> signInWithGoogle(BuildContext context) async {
  // 개발모드일 때 이메일 인증만 가능
  if (isLocalDevelopment) {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: localUser.first, password: localUser.last);

    return userCredential;
  }

  // 1. 구글 인증 진행
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // 로그인을 취소했거나 토큰을 얻지 못했으면
  if (googleAuth?.accessToken == null) {
    return null;
  }

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // 2. 구글 토큰으로 파이베이스 인증 완료
  // Once signed in, return the UserCredential
  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  if (userCredential.user != null) {
    var user = userCredential.user;
    log(user.toString());
  }

  return userCredential;
}

Future<void> signOut() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
}

String getUid() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    return currentUser.uid;
  }
  return "";
}
