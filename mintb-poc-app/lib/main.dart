import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/env.dart';
import 'package:mintb_poc_app/firebase/auth.dart';
import 'package:mintb_poc_app/firebase/firestore/profiles_collection.dart';
import 'package:mintb_poc_app/preferences/profile_local.dart';
import 'package:mintb_poc_app/screens/auth/birthday_form.dart';
import 'package:mintb_poc_app/screens/auth/gender_form.dart';
import 'package:mintb_poc_app/screens/auth/language_form.dart';
import 'package:mintb_poc_app/screens/auth/language_priority_form.dart';
import 'package:mintb_poc_app/screens/auth/nickname_form.dart';
import 'package:mintb_poc_app/screens/auth/phone_country.dart';
import 'package:mintb_poc_app/screens/auth/phone_verification.dart';
import 'package:mintb_poc_app/screens/auth/phone_verification_code.dart';
import 'package:mintb_poc_app/screens/auth/policy_confirm.dart';
import 'package:mintb_poc_app/screens/auth/privacy_policy.dart';
import 'package:mintb_poc_app/screens/auth/profile_image_registration.dart';
import 'package:mintb_poc_app/screens/auth/sign_in.dart';
import 'package:mintb_poc_app/screens/auth/welcome_privacy.dart';
import 'package:mintb_poc_app/screens/home.dart';
import 'package:mintb_poc_app/screens/profile/wallet_send_form.dart';
import 'package:mintb_poc_app/screens/profile/wallet_send_review.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  final initRoute = await loadProfile();

  runApp(MyApp(
    initialRoute: initRoute,
  ));
}

// 파이어베이스앱 초기화
Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(FirebaseAuth.instance.currentUser.toString());

  if (isLocalDevelopment) {
    // 로컬 에뮬레이터 사용
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
  }
}

Future<String> loadProfile() async {
  if (getUid() != "") {
    final profile = await fetchProfile();
    if (profile != null) {
      saveProfileLocal(ProfileLocal(
          nickname: profile.nickname,
          age: profile.age,
          gender: profile.gender,
          images: profile.images,
          languages: profile.languages));

      return "/";
    }
  }

  return "/auth/sign-in";
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MintB POC App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF25ECD7),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const Home(),
        '/auth/sign-in': (context) => const SignIn(),
        '/auth/welcome-privacy': (context) => const WelcomePrivacy(),
        '/auth/privacy-policy': (context) => const PrivacyPolicy(),
        '/auth/phone-verification': (context) => const PhoneVerification(),
        '/auth/phone-country': (context) => const PhoneCountry(),
        '/auth/phone-verification-code': (context) =>
            const PhoneVerificationCode(),
        '/auth/nickname-form': (context) => const NicknameForm(),
        '/auth/birthday-form': (context) => const BirthdayForm(),
        '/auth/gender-form': (context) => const GenderForm(),
        '/auth/profile-image-registration': (context) =>
            const ProfileImageRegistration(),
        '/auth/language-form': (context) => const LanguageForm(),
        '/auth/language-priority-form': (context) =>
            const LanguagePriorityForm(),
        '/auth/policy-confirm': (context) => const PolicyConfirm(),
        '/profile/wallet/send-form': (context) => const WalletSendForm(),
        '/profile/wallet/send-review': (context) => const WalletSendReview()
      },
    );
  }
}
