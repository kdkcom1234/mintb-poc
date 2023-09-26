import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/sign_in.dart';
import 'package:mintb_poc_app/screens/todo_detail.dart';
import 'package:mintb_poc_app/screens/todo_form.dart';
import 'package:mintb_poc_app/screens/todo_list.dart';

import 'firebase/auth.dart';
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
      ),
      initialRoute: getUid() == "" ? "/sign-in" : "/",
      routes: {
        '/': (context) => const TodoList(),
        '/sign-in': (context) => const SignIn(),
        "/form": (context) => const TodoForm(),
        "/detail": (context) => const TodoDetail()
      },
    );
  }
}
