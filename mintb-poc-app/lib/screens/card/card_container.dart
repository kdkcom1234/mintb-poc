import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/card/card_empty.dart';

import '../../constants.dart';
import '../../firebase/firestore/profile_collection.dart';
import '../../widgets/text_chip.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, this.profileCard, this.onFilterPressed});
  final ProfileCollection? profileCard;
  final VoidCallback? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    // 전체 화면 높이
    double screenHeight = MediaQuery.of(context).size.height;
    // 상단 상태바 높이
    double statusBarHeight = MediaQuery.of(context).padding.top;
    // 하단 버튼 영역 높이 (예: Android의 소프트 키, iPhone의 홈 인디케이터 등)
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    final usableScreenHeight =
        screenHeight - statusBarHeight - bottomPadding - 51;

    final profileCard = this.profileCard;

    if (profileCard == null) {
      return CardEmpty(onFilterPressed: onFilterPressed!);
    }

    return Container(
        key: Key(profileCard.id!),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C26),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListView(
          children: [
            // 메인 프로필
            Container(
                // 앱 내부영역 - 상단거리 - (탭바사이 + 탭바)
                height: usableScreenHeight - 51 - 20 - 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(profileCard.images[0]),
                    fit: BoxFit.cover,
                  ),
                ),
                // 프로필 기본 내용
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 38,
                      left: 18,
                      child: SizedBox(
                        height: 51,
                        width: MediaQuery.of(context).size.width - 62,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${profileCard.nickname}, ${profileCard!.age}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 1.0,
                                        color: Color.fromRGBO(0, 0, 0, 0.60),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  profileCard.gender == 0
                                      ? "Influencer, 168cm"
                                      : "Surgeon General, 185cm",
                                  style: const TextStyle(
                                    color: Color(0xFFD5DBDB),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 1.0,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/check_badge.png",
                                  width: 20,
                                  height: 20.15,
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Image.asset(
                                  "assets/profile_badge.png",
                                  width: 20,
                                  height: 20.98,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            // 상세 프로필
            Container(
              padding: const EdgeInsets.only(
                  top: 24, bottom: 21, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '내 소개',
                    style: TextStyle(
                      color: Color(0xFFB2BABB),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    '기본 정보',
                    style: TextStyle(
                      color: Color(0xFFB2BABB),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Wrap(
                    spacing: 8, // 가로 방향으로의 아이템 간 간격
                    runSpacing: 12, // 세로 방향으로의 줄 간 간격
                    children: [
                      TextChip("비흡연자"),
                      TextChip("기독교"),
                      TextChip("쌍둥이자리"),
                      TextChip("진보성향"),
                      TextChip("음주는 때때로"),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    '내 관심사',
                    style: TextStyle(
                      color: Color(0xFFB2BABB),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Wrap(
                    spacing: 8, // 가로 방향으로의 아이템 간 간격
                    runSpacing: 12, // 세로 방향으로의 줄 간 간격
                    children: [
                      TextChip("예술"),
                      TextChip("노래"),
                      TextChip("메이크업"),
                      TextChip("영화"),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    '구사언어',
                    style: TextStyle(
                      color: Color(0xFFB2BABB),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Wrap(
                    spacing: 8, // 가로 방향으로의 아이템 간 간격
                    runSpacing: 12, // 세로 방향으로의 줄 간 간격
                    children: profileCard!.languages
                        .map((e) => TextChip(
                              languages[e],
                              key: Key(e.toString()),
                            ))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 29,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: profileCard!.nickname,
                          style: const TextStyle(
                            color: Color(0xFFFFB74D),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const TextSpan(
                          text: ' 님의 위치',
                          style: TextStyle(
                            color: Color(0xFFB2BABB),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Wrap(
                    spacing: 8, // 가로 방향으로의 아이템 간 간격
                    runSpacing: 12, // 세로 방향으로의 줄 간 간격
                    children: [
                      TextChip("대한민국 서울"),
                    ],
                  ),
                ],
              ),
            ),
            // 추가 이미지 목록
            Column(
                children: profileCard!.images
                    .where((e) => profileCard!.images.indexOf(e) != 0)
                    .toList()
                    .map((e) => Image.network(
                          e,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ))
                    .toList()),
            // 하단 버튼
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    // Flex 값을 1로 설정
                    child: SizedBox(
                      height: 50, // 높이 설정
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼 클릭 시 수행할 작업
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF343434), // 배경 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                          ),
                          padding: EdgeInsets.zero, // 내부 패딩 제거
                          // 텍스트 스타일은 아래에서 설정
                        ),
                        child: const Text(
                          'Dislike',
                          style: TextStyle(
                            color: Color(0xFF3EDFCF),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    // Flex 값을 1로 설정
                    child: SizedBox(
                      height: 50, // 높이 설정
                      child: ElevatedButton(
                        onPressed: () {
                          // 버튼 클릭 시 수행할 작업
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3EDFCF), // 배경 색상
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                          ),
                          padding: EdgeInsets.zero, // 내부 패딩 제거
                          // 텍스트 스타일은 아래에서 설정
                        ),
                        child: const Text(
                          'Like',
                          style: TextStyle(
                            color: Color(0xFF343434),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
