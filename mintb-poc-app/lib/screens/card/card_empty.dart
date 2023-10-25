import 'package:flutter/material.dart';

class CardEmpty extends StatelessWidget {
  const CardEmpty({super.key, required this.onFilterPressed});
  final VoidCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: SizedBox(
          height: 147,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '모두 확인하셨어요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF3EDFCF),
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const Text(
                '근처 회원을 모두 보여드렸습니다. \n필터 조건을 변경하시거나 나중에 다시 확인하세요.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFD5DBDB),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업을 여기에 작성합니다.
                  onFilterPressed();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25ECD7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(200, 50),
                ),
                child: const Text(
                  '내 필터 변경하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF343434),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ), // 필요한 버튼 텍스트로 변경해주세요.
              )
            ],
          ),
        ),
      ),
    );
  }
}
