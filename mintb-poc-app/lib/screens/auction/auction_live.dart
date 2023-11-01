import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/profile_collection.dart';
import 'package:mintb_poc_app/screens/auction/auction_live_card.dart';
import 'package:mintb_poc_app/screens/auction/auction_live_profile.dart';

import '../../firebase/firestore/auction_collection.dart';

typedef IntCallback = void Function(int value);

class AuctionLive extends StatefulWidget {
  const AuctionLive(
      {super.key, required this.onPageChanged, required this.initPage});
  final IntCallback onPageChanged;
  final int initPage;

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveState();
  }
}

class _AuctionLiveState extends State<AuctionLive> {
  List<AuctionLiveCard> auctionCardList = [];
  final pageController = PageController();
  var loadingPage = 0;
  var currentPage = 0;

  Future<void> setAuctionLiveCards() async {
    final auctionList = await fetchAuctionLiveList();
    if (auctionList.isNotEmpty) {
      setState(() {
        auctionCardList = auctionList.map((e) => AuctionLiveCard(e)).toList();
        if (widget.initPage != 0) {
          pageController.jumpToPage(widget.initPage);
          loadingPage = widget.initPage;
          currentPage = loadingPage;
          widget.onPageChanged(currentPage);
          loadNextPageProfile();
        }
      });

      // 첫번째 페이지의 프로필을 로딩한다.
      final firstCardProfile = await fetchProfile(id: auctionList[0].profileId);
      if (firstCardProfile != null) {
        setState(() {
          auctionCardList[0] = AuctionLiveCard(
            auctionList[0],
            profileData: firstCardProfile,
          );
        });
      }
    }
  }

  Future<void> loadNextPageProfile() async {
    final profile = await fetchProfile(
        id: auctionCardList[loadingPage].auctionData.profileId);
    if (profile != null) {
      setState(() {
        auctionCardList[loadingPage] = AuctionLiveCard(
          auctionCardList[loadingPage].auctionData,
          profileData: profile,
        );
      });
    }
  }

  void handlePageChange() {
    // 다음 페이지로 넘어갈 때 프로필을 로딩한다.
    if (pageController.page!.ceil() > loadingPage) {
      loadingPage = pageController.page!.ceil();
      loadNextPageProfile();
    }
    // 이전 페이지로 넘어갈 때 로딩되지 않을 프로필이 있으면 로딩한다.
    if (pageController.page!.floor() < loadingPage) {
      final index = pageController.page!.floor();
      if (auctionCardList[index].profileData == null) {
        loadingPage = pageController.page!.floor();
        loadNextPageProfile();
      }
    }

    // 현재페이지번호 상태 업데이트
    setState(() {
      currentPage = pageController.page!.round();
      widget.onPageChanged(currentPage);
    });
  }

  Timer? timer;
  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (auctionCardList.isNotEmpty) {
        setState(() {
          final currentCard = auctionCardList[currentPage];
          auctionCardList[currentPage] = AuctionLiveCard(
            currentCard.auctionData,
            profileData: currentCard.profileData,
          );
        });
      }
    });
  }

  void handleOpenProfile(int index) async {
    // 시간 계산 정지
    timer?.cancel();
    // 프로필 팝업  띄움
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AuctionLiveProfile(
          profileData: auctionCardList[index].profileData,
          auctionData: auctionCardList[index].auctionData),
      fullscreenDialog: true,
    ));
    // 시간 계산 시작
    tickTimeRemaining();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setAuctionLiveCards();
    tickTimeRemaining();

    pageController.addListener(handlePageChange);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: auctionCardList.length,
                  itemBuilder: (ctx, index) => InkWell(
                      onTap: () {
                        handleOpenProfile(index);
                      },
                      child: auctionCardList[index]),
                  controller: pageController,
                ))),
        // 페이지 인디케이터
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            width: MediaQuery.of(context).size.width,
            height: 10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: auctionCardList
                    .map((e) => auctionCardList.indexOf(e))
                    .map((e) => Row(
                          children: [
                            e != 0
                                ? const SizedBox(
                                    width: 8,
                                  )
                                : const SizedBox.shrink(),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: ShapeDecoration(
                                  color: e == currentPage
                                      ? const Color(0xFF3EDFCF)
                                      : const Color(0xFF1C1C26),
                                  shape: e == currentPage
                                      ? const OvalBorder()
                                      : const OvalBorder(
                                          side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF3EDFCF)),
                                        )),
                            ),
                          ],
                        ))
                    .toList()),
          ),
        )
      ],
    );
  }
}
