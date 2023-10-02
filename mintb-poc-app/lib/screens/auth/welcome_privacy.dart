import 'package:flutter/material.dart';

class WelcomePrivacy extends StatefulWidget {
  const WelcomePrivacy({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WelcomePrivacyState();
  }
}

class _WelcomePrivacyState extends State<WelcomePrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 28, left: 16),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Image(
                            image: AssetImage('assets/back_button.png'),
                            width: 16,
                          ),
                        ))
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 16),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome to',
                              style: TextStyle(
                                color: Color(0xFFE5E5E5),
                                fontSize: 32,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                            TextSpan(
                              text: ' MintB',
                              style: TextStyle(
                                color: Color(0xFF3DDFCE),
                                fontSize: 32,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
