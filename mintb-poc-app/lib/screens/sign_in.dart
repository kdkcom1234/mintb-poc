import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends State<SignIn> {
  var loginProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 220),
                  child: Image(
                    image: AssetImage('assets/logo_login.png'),
                    width: 217.21,
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 22),
                      child: Text(
                        '“ We are MEANT TO BE ”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFBBC05),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 223, left: 16, right: 16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFFFBFBFB)),
                      onPressed: () async {
                        final result = await signInWithGoogle(context);
                        if (result.user != null) {
                          if (!mounted) return;
                          Navigator.of(context).pushNamed("/welcome-privacy");
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Image(
                              image: AssetImage('assets/google_icon.png'),
                              width: 20,
                            ),
                          ),
                          Text(
                            'Sign in with Google',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFFFBFBFB)),
                      onPressed: () {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Image(
                              image: AssetImage('assets/apple_icon.png'),
                              width: 20,
                            ),
                          ),
                          Text(
                            'Sign in with Apple',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ))));
  }
}
