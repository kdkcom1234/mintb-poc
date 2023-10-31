import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auction/auction_live.dart';
import 'package:mintb_poc_app/screens/auction/auction_mybid.dart';

class AuctionMain extends StatefulWidget {
  const AuctionMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionMainState();
  }
}

class _AuctionMainState extends State<AuctionMain> {
  var currentIndex = 0;
  var currentLivePage = 0;

  void handleLivePageChanged(int page) {
    currentLivePage = page;
  }

  void changeTabsIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF343434),
            child: SafeArea(
              child: Column(
                children: [
                  /* -- 탭 컨트롤 --*/
                  Container(
                    width: 176,
                    height: 40,
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [0, 1]
                          .map(
                            (e) => InkWell(
                              onTap: () {
                                changeTabsIndex(e);
                              },
                              child: Container(
                                  width: 88,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: currentIndex == e
                                        ? const Color(0xFF3DDFCE)
                                        : const Color(0xFF343434),
                                    shape: RoundedRectangleBorder(
                                      side: currentIndex == e
                                          ? BorderSide.none
                                          : const BorderSide(
                                              width: 1,
                                              color: Color(0xFF3EDFCF)),
                                      borderRadius: e == 0
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            )
                                          : const BorderRadius.only(
                                              topRight: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e == 0 ? 'Live' : "내 입찰",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: currentIndex == e
                                            ? const Color(0xFF343434)
                                            : const Color(0xFF949494),
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  )),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  currentIndex == 0
                      ? const SizedBox(
                          height: 32,
                        )
                      : const SizedBox(
                          height: 16,
                        ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        currentIndex == 0
                            ? AuctionLive(
                                initPage: currentLivePage,
                                onPageChanged: handleLivePageChanged,
                              )
                            : const AuctionMyBid()
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
