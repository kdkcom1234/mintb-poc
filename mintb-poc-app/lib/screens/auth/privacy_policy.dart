import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/titled_appbar.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(color: Color(0xFF343434)),
      child: const SafeArea(
          child: Column(
        children: [
          TitledAppBar("개인정보 처리 방침"),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  'Privacy Policy ',
                  style: TextStyle(
                    color: Color(0xFFD1D1D1),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          )
        ],
      )),
    ));
  }
}
