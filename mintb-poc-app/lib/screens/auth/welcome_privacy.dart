import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

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
                /* -- back navigation */
                Row(
                  children: [BackNavButton(context)],
                ),
                /* -- text contents */
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text.rich(
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
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          width: MediaQuery.of(context).size.width - 32,
                          child: const Text(
                            '회원가입을 위해 개인정보 처리방침에 대한 동의를 받고자 합니다.'
                            '\n\n회원님의 개인정보의 이용목적은 투명하게 관리되며 회원님이 원하실 때, 언제든지 설정을 변경하거나 이용에 대해서 거부하실 수 있습니다.'
                            '\n\nmintB는 회원님의 개인정보를 보호하기 위해 최선의 노력을 다하도록 하겠습니다.',
                            style: TextStyle(
                              color: Color(0xFFD1D1D1),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(top: 24),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed("/auth/privacy-policy");
                              },
                              child: const Text(
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
                            ))
                      ],
                    ),
                  ),
                ),
                /* -- bottom button */
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: const Color(0xFF25ECD7),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed("/auth/phone-verification");
                    },
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
            ),
          )),
    );
  }
}
