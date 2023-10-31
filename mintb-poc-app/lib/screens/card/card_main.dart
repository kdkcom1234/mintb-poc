import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/preferences/filter_local.dart';
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
  Timestamp? lastTimestamp;
  ProfileLocal? profileLocal;
  FilterLocal? filterLocal;
  List<CardContainer> profileCardList = [];

  var loading = false;
  PageController? pageController;

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

  Future<void> loadFirstCard() async {
    final emptyContainer = CardContainer(
      height: cardContainerHeight,
      key: const Key("empty"),
      onFilterPressed: handleFilterPressed,
    );

    final dummyContainer = CardContainer(
      height: cardContainerHeight,
      isDummy: true,
    );

    // 프로필 정보 조회
    profileLocal ??= await getProfileLocal();
    // 조회 성별을 상대 성별로
    final selectedGender = profileLocal!.gender == 0 ? 1 : 0;
    // 필터 정보 조회
    filterLocal ??= await getFilterLocal();

    final profileDataList = await fetchProfileList(selectedGender,
        lastTimestamp: lastTimestamp,
        ageMin: filterLocal?.ageMin,
        ageMax: filterLocal?.ageMax);

    // 조회된 데이터가 있을 때
    if (profileDataList.isNotEmpty) {
      final firstCard = CardContainer(
        height: cardContainerHeight,
        profileData: profileDataList[0],
        key: Key(profileDataList[0].id!),
      );
      setState(() {
        // 첫번째 데이터로 카드 추가
        profileCardList.add(firstCard);
        // 좌우에 데미 페이지 추가
        profileCardList.add(dummyContainer);
        profileCardList.insert(0, dummyContainer);
      });

      lastTimestamp = profileDataList[0].createdAt;

      pageController = PageController(keepPage: false, initialPage: 1);
      pageController!.addListener(handlePageChanged);
    }
    // 조회된 데이터가 없을 때
    else {
      setState(() {
        profileCardList.add(emptyContainer);
      });
      pageController = PageController(keepPage: false, initialPage: 0);
    }
  }

  Future<void> loadNextCard({String? direction}) async {
    final emptyContainer = CardContainer(
      height: cardContainerHeight,
      key: const Key("empty"),
      onFilterPressed: handleFilterPressed,
    );

    // 프로필 정보 조회
    profileLocal ??= await getProfileLocal();
    // 조회 성별을 상대 성별로
    final selectedGender = profileLocal!.gender == 0 ? 1 : 0;
    // 필터 정보 조회
    filterLocal ??= await getFilterLocal();

    // 다른 페이지부터는 다음 데이터만 로딩한다.
    final profileDataList = await fetchProfileList(selectedGender,
        lastTimestamp: lastTimestamp,
        ageMin: filterLocal?.ageMin,
        ageMax: filterLocal?.ageMax);

    // 조회된 데이터가 있을 때
    if (profileDataList.isNotEmpty) {
      final profileCard = CardContainer(
        height: cardContainerHeight,
        profileData: profileDataList[0],
        key: Key(profileDataList[0].id!),
      );

      setState(() {
        // 이동 중인 페이지에 프로필 카드 로드
        if (direction == "right") {
          profileCardList[pageController!.page!.ceil()] = profileCard;
        } else if (direction == "left") {
          profileCardList[pageController!.page!.floor()] = profileCard;
        }

        lastTimestamp = profileDataList[0].createdAt;
      });
    }
    // 조회된 데이터가 없을 때
    else {
      setState(() {
        // 이동중인 페이지에 빈 화면 추가
        if (direction == "right") {
          profileCardList[pageController!.page!.ceil()] = emptyContainer;
        } else if (direction == "left") {
          profileCardList[pageController!.page!.floor()] = emptyContainer;
        }
      });
    }
  }

  Future<void> loadSideDummyCard({String? direction}) async {
    final dummyContainer = CardContainer(
      height: cardContainerHeight,
      isDummy: true,
    );

    final emptyContainer = CardContainer(
      height: cardContainerHeight,
      key: const Key("empty"),
      onFilterPressed: handleFilterPressed,
    );

    // 이동한 페이지의 프로필이 없으면(빈페이지)
    if (pageController != null &&
        profileCardList[pageController!.page!.toInt()].profileData == null) {
      log("empty page");
      setState(() {
        profileCardList.clear();
        profileCardList.add(emptyContainer);
        pageController!.removeListener(handlePageChanged);
        pageController!.jumpToPage(0);
      });
      return;
    }

    // 슬라이드 방향 좌우에 더미를 추가한다.
    if (direction == "right") {
      setState(() {
        // 0 1(현재) 2
        // ->
        // 0 1(더미) 2(현재)
        // 0 1(더미) 2(현재) 3(더미)
        // 0(삭제) 1(더미) 2(현재) 3(더미)
        // 0(더미) 1(현재) 2(더미)
        profileCardList[pageController!.page!.toInt() - 1] = dummyContainer;
        profileCardList.add(dummyContainer);
        profileCardList.removeAt(0);
        pageController!.jumpToPage(1);
      });
    } else if (direction == "left") {
      setState(() {
        // 0 1(현재) 2
        // <-
        // 0(현재) 1(더미) 2
        // 0(더미) 1(현재) 2(더미) 3
        // 0(더미) 1(현재) 2(더미) 3(삭제)
        // 0(더미) 1(현재) 2(더미)
        profileCardList[pageController!.page!.toInt() + 1] = dummyContainer;
        profileCardList.insert(0, dummyContainer);
        profileCardList.removeAt(3);
        pageController!.jumpToPage(1);
      });
    }
  }

  void handleFilterPressed() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CardFilter(),
      fullscreenDialog: true,
    ));
    setState(() {
      lastTimestamp = null;
      pageController = null;
      filterLocal = null;
      profileCardList.clear();
    });
    loadFirstCard();
  }

  void handleRevertPressed() async {
    setState(() {
      lastTimestamp = null;
      pageController = null;
      filterLocal = null;
      profileCardList.clear();
    });
    loadFirstCard();
  }

  void handlePageChanged() {
    // 이동 중일때 다음 프로필 카드 로드
    if (pageController!.page!.floor() == 0 && !loading) {
      loading = true;
      loadNextCard(direction: "left");
    }
    if (pageController!.page!.ceil() == 2 && !loading) {
      loading = true;
      loadNextCard(direction: "right");
    }

    // 이동 완료면 좌우에 더미카드 로드
    if (pageController!.page! == 0.0) {
      loadSideDummyCard(direction: "left");
      loading = false;
    }
    if (pageController!.page! == 2.0) {
      loadSideDummyCard(direction: "right");
      loading = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFirstCard();
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
                  onRevertPressed: handleRevertPressed,
                  onFilterPressed: handleFilterPressed,
                ),
                Expanded(
                    child: pageController == null
                        ? const SizedBox.expand()
                        : Container(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, top: 18.2, bottom: 20),
                            color: const Color(0xFF343434),
                            child: PageView.builder(
                              itemCount: profileCardList.length,
                              itemBuilder: (ctx, index) =>
                                  profileCardList[index],
                              controller: pageController,
                            )))
              ],
            ),
          )),
    );
  }
}
