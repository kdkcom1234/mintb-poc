import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mintb_poc_app/preferences/profile_local.dart';
import 'package:mintb_poc_app/screens/card/card_appbar.dart';
import 'package:mintb_poc_app/screens/card/card_filter.dart';

import '../../firebase/firestore/profile_collection.dart';
import 'card_container.dart';

class CardMain extends StatefulWidget {
  const CardMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardMainState();
  }
}

class _CardMainState extends State<CardMain> {
  String? currentProfileId;
  ProfileLocal? profileLocal;
  List<CardContainer> profileCardList = [];

  var selectedGender = 1;
  var loading = true;
  var isLast = false;

  PageController pageController = PageController(keepPage: true);
  var currentPage = 0;

  double cardContainerHeight = 0;

  void loadCard() async {
    setState(() {
      loading = true;
    });

    profileLocal = await getProfileLocal();
    if (profileLocal != null) {
      selectedGender = profileLocal!.gender == 0 ? 1 : 0;

      // 첫 페이지에만 2개를 로딩한다.
      // 2번째 페이지부터는 다음 페이지만 로딩한다.
      final profileCards = await fetchProfilesPairByGender(selectedGender,
          currentProfileId: currentProfileId);

      if (profileCards.isNotEmpty) {
        for (final profileCard in profileCards) {
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            profileCard: profileCard,
            key: Key(profileCard.id!),
          ));

          currentProfileId = profileCard!.id;
        }
        // 첫페이지면서 1개만 로딩됐으면 다음 페이지는 빈페이지 처리
        if (currentPage == 0 && profileCards.length == 1) {
          isLast = true;
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            key: const Key("empty"),
            onFilterPressed: handleFilterPressed,
          ));
        }
      } else {
        if (!isLast) {
          // 조회된 데이터가 없을 때
          isLast = true;
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            key: const Key("empty"),
            onFilterPressed: handleFilterPressed,
          ));
        }
      }
    }

    log(profileCardList.length.toString());
    setState(() {
      loading = false;
    });
  }

  void handleFilterPressed() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CardFilter(),
      fullscreenDialog: true,
    ));
    currentProfileId = null;
    currentPage = 0;
    profileCardList.clear();
    isLast = false;
    loadCard();
  }

  void handlePageChanged() {
    final newPage = pageController.page!.floor();

    if (newPage > currentPage) {
      currentPage = newPage;
      log("new page index: $newPage");
      loadCard();
    } else if (newPage < currentPage) {
      currentPage = newPage;
      log("new page index: $newPage");
    }
  }

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
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController.addListener(handlePageChanged);
    loadCard();
  }

  @override
  Widget build(BuildContext context) {
    setCardContainerHeight(context);

    return Scaffold(
      body: Container(
          color: const Color(0xFF343434),
          child: SafeArea(
            child: Column(
              children: [
                CardAppbar(
                  onRevertPressed: () {},
                  onFilterPressed: handleFilterPressed,
                ),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, top: 18.2, bottom: 20),
                        color: const Color(0xFF343434),
                        child: PageView.builder(
                          itemCount: profileCardList.length,
                          itemBuilder: (ctx, index) => profileCardList[index],
                          controller: pageController,
                        )))
              ],
            ),
          )),
    );
  }
}
