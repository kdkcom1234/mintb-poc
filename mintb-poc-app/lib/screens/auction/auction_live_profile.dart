import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/card/card_container.dart';

import '../../firebase/firestore/auction_collection.dart';
import '../../firebase/firestore/profile_collection.dart';

class AuctionLiveProfile extends StatefulWidget {
  const AuctionLiveProfile(
      {super.key, this.profileData, required this.auctionData});
  final AuctionCollection auctionData;
  final ProfileCollection? profileData;

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveProfileState();
  }
}

class _AuctionLiveProfileState extends State<AuctionLiveProfile> {
  double cardContainerHeight = 0;
  void setCardContainerHeight(BuildContext context) {
    // 전체 화면 높이
    double screenHeight = MediaQuery.of(context).size.height;
    // 상단 상태바 높이
    double statusBarHeight = MediaQuery.of(context).padding.top;
    // 하단 버튼 영역 높이 (예: Android의 소프트 키, iPhone의 홈 인디케이터 등)
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    // 앱 내부영역 - 상단거리 - (탭바사이 + 탭바)
    cardContainerHeight =
        screenHeight - statusBarHeight - bottomPadding - 51 - 20 - 48;
  }

  @override
  Widget build(BuildContext context) {
    setCardContainerHeight(context);

    return Scaffold(
        body: Container(
            color: const Color(0xFF343434),
            child: SafeArea(
                child: Stack(children: [
              // 상단 바
              Container(
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
                      widget.profileData!.nickname,
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
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 16, top: 48 + 16),
                          child: CardContainer(
                              profileData: widget.profileData,
                              height: cardContainerHeight))),
                ],
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 74,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(28, 28, 38, 0.70),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.50),
                            blurRadius: 2.0,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // 버튼이 눌렸을 때 수행할 작업
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EDFCF), // 배경 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Pretendard', // 폰트
                              fontWeight: FontWeight.w700, // 굵기
                              fontSize: 16, // 폰트 크기
                            ),
                          ),
                          child: const Text(
                            '입찰하기',
                            style: TextStyle(
                              color: Color(0xFF343434), // 텍스트 색상
                              height: 0, // 텍스트 높이 (line height)
                            ),
                          ),
                        ),
                      )))
            ]))));
  }
}
