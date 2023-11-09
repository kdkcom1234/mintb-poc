import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auction/auction_history.dart';
import 'package:mintb_poc_app/screens/auction/auction_live.dart';
import 'package:mintb_poc_app/screens/auction/auction_request.dart';

class AuctionMain extends StatefulWidget {
  const AuctionMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionMainState();
  }
}

class _AuctionMainState extends State<AuctionMain> {
  void handleAuctionRequest() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuctionRequest(),
      fullscreenDialog: true,
    ));
  }

  void handleAuctionHistory() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AuctionHistory(),
      fullscreenDialog: true,
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF343434),
            child: SafeArea(
              child: Column(
                children: [
                  /* -- 내역 및 신청 버튼 --*/
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 22, left: 12, right: 18, bottom: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: handleAuctionHistory,
                          child: Image.asset(
                            "assets/list_button.png",
                            width: 40,
                            height: 40,
                          ),
                        ),
                        InkWell(
                          onTap: handleAuctionRequest,
                          child: Container(
                            width: 88,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: const Color(0xFF343434),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 1, color: Color(0xFF3EDFCF)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                '경매신청',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3EDFCF),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  /* -- 라이브 카드 페이지 --*/
                  const Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [AuctionLive()],
                    ),
                  )
                ],
              ),
            )));
  }
}
