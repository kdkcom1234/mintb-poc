import 'package:flutter/material.dart';

import '../../widgets/back_nav_button.dart';

class PhoneVerificationCode extends StatefulWidget {
  const PhoneVerificationCode({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PhoneVerificationCodeState();
  }
}

class _PhoneVerificationCodeState extends State<PhoneVerificationCode> {
  final codes = ["7", "2", "3", "7", "5", "1"];

  @override
  Widget build(BuildContext context) {
    // countryCode, phone
    final Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(children: [
              /* -- back navigation */
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: BackNavButton(context),
                  )
                ],
              ),
              /* -- text contents */
              Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 40),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          '인증코드 입력',
                          style: TextStyle(
                              color: Color(0xFF3EDFCF),
                              fontSize: 32,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${args["countryCode"]} ${args["phone"]}",
                              style: const TextStyle(
                                color: Color(0xFFFBBC05),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            const TextSpan(
                              text: '로 전송된 코드를 입력해주세요.',
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /* -- code field */
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (final (index, item) in codes.indexed)
                  Container(
                    width: 40,
                    height: 48,
                    margin: EdgeInsets.only(right: index == 5 ? 0 : 8),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF343434),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  )
              ])
            ]))));
  }
}
