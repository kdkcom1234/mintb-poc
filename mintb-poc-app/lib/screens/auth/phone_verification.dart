import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PhoneVerificationState();
  }
}

class _PhoneVerificationState extends State<PhoneVerification> {
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
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: BackNavButton(context),
                  )
                ],
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      '휴대폰 번호인증',
                      style: TextStyle(
                        color: Color(0xFF3EDFCF),
                        fontSize: 32,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                  )
                ],
              )
            ],
          ))),
    );
  }
}
