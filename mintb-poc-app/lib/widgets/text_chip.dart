import 'package:flutter/cupertino.dart';

class TextChip extends StatelessWidget {
  const TextChip(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 60, // 최소 너비를 100으로 설정
      ),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 11),
      decoration: ShapeDecoration(
        color: const Color(0xFF282831),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 2,
            offset: Offset(2, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF3EDFCF),
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 0,
        ),
      ),
    );
  }
}
