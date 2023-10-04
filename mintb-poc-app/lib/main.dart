import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auth/birthday_form.dart';
import 'package:mintb_poc_app/screens/auth/gender_form.dart';
import 'package:mintb_poc_app/screens/auth/nickname_form.dart';
import 'package:mintb_poc_app/screens/auth/phone_country.dart';
import 'package:mintb_poc_app/screens/auth/phone_verfication_code.dart';
import 'package:mintb_poc_app/screens/auth/phone_verification.dart';
import 'package:mintb_poc_app/screens/auth/privacy_policy.dart';
import 'package:mintb_poc_app/screens/auth/profile_image_registration.dart';
import 'package:mintb_poc_app/screens/auth/sign_in.dart';
import 'package:mintb_poc_app/screens/auth/welcome_privacy.dart';
import 'package:mintb_poc_app/screens/card/card-main.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();

  runApp(const MyApp());
}

// 파이어베이스앱 초기화
initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(FirebaseAuth.instance.currentUser.toString());

  // 개발모드일 때 로컬 에뮬레이터 사용
  // if (kDebugMode) {
  //   try {
  //     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // initialRoute: getUid() == "" ? "/auth/sign-in" : "/",
      initialRoute: "/auth/sign-in",
      routes: {
        '/': (context) => const CardMain(),
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
      },
    );
  }
}
