import 'package:flutter/material.dart';

class CloseableTitledAppbar extends StatelessWidget {
  const CloseableTitledAppbar(this.title, {super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(
                    "assets/close_button.png",
                    width: 38,
                    height: 38,
                  ),
                ),
              )),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE5E5E5),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w800,
              height: 0,
            ),
          ),
          const SizedBox(
            width: 48,
            height: 48,
          )
        ],
      ),
    );
  }
}
