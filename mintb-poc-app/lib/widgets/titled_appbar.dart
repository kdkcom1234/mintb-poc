import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

class TitledAppBar extends StatelessWidget {
  const TitledAppBar(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackNavButton(
            context,
            padding: const EdgeInsets.only(top: 5, left: 5),
          ),
          const Text(
            '개인정보 처리 방침',
            style: TextStyle(
              color: Color(0xFFE5E5E5),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          ),
          const SizedBox(
            width: 43,
            height: 43,
          )
        ],
      ),
    );
  }
}
