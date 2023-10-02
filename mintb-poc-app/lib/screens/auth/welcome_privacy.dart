import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/back_button_light.dart';

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
                  children: [BackButtonLight(context)],
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
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16),
                      child: Text(
                        '회원가입을 위해 개인정보 처리방침에 대한 동의를\n받고자 합니다.\n\n회원님의 개인정보의 이용목적은 투명하게 관리되며\n회원님이 원하실 때, 언제든지 설정을 변경하거나\n이용에 대해서 거부하실 수 있습니다.\n\nmintB는 회원님의 개인정보를 보호하기 위해 최선의\n노력을 다하도록 하겠습니다.',
                        style: TextStyle(
                          color: Color(0xFFD1D1D1),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 24, left: 16),
                      child: Text(
                        '개인정보 처리방침 자세히 보기',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Color(0xFFFBBC05),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          bottom: 16, left: 16, right: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: const Color(0xFF25ECD7),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () {},
                        child: const Text(
                          '개인정보 처리방침 동의',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF343434),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ))
              ],
            ),
          )),
    );
  }
}
