import 'package:flutter/material.dart';

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
            child: const SafeArea(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 220),
                      child: Image(
                        image: AssetImage('assets/logo_login.png'),
                        width: 217.21,
                      ),
                    )
                  ],
                ),
                Row(
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
                )
              ],
            ))));
  }
}
