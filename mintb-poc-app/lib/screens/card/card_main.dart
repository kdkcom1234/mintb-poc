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

  var loading = true;
  var isLast = false;

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

  Future<void> loadCard({String? direction}) async {
    setState(() {
      loading = true;
    });

    final emptyContainer = CardContainer(
      height: cardContainerHeight,
      key: const Key("empty"),
      onFilterPressed: handleFilterPressed,
    );

    final dummyContainer = CardContainer(
      height: cardContainerHeight,
      isDummy: true,
    );

    // 이동한 페이지의 프로필이 없으면(빈페이지)
    if (pageController != null &&
        profileCardList[pageController!.page!.toInt()].profileCard == null) {
      setState(() {
        profileCardList.clear();
        profileCardList.add(emptyContainer);
        pageController!.jumpToPage(0);
      });
      return;
    }

    // 프로필 정보 조회
    profileLocal ??= await getProfileLocal();
    // 조회 성별을 상대 성별로
    final selectedGender = profileLocal!.gender == 0 ? 1 : 0;
    // 필터 정보 조회
    filterLocal ??= await getFilterLocal();

    // 첫 로딩일 때
    if (lastTimestamp == null) {
      // 첫 페이지에만 2개를 로딩한다.
      // 2번째 페이지부터는 다음 페이지만 로딩한다.
      final profileCards = await fetchProfileList(selectedGender,
          lastTimestamp: lastTimestamp,
          ageMin: filterLocal?.ageMin,
          ageMax: filterLocal?.ageMax);

      // 조회된 데이터가 있을 때
      if (profileCards.isNotEmpty) {
        // 1건만 있을 때(이후 데이터 없음)
        if (profileCards.length == 1) {
          isLast = true;
          // 첫번째 데이터로 카드 추가
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            profileCard: profileCards[0],
            key: Key(profileCards[0].id!),
          ));
          // 앞뒤에 빈페이지 추가
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            key: const Key("empty"),
            onFilterPressed: handleFilterPressed,
          ));
          profileCardList.insert(
              0,
              CardContainer(
                height: cardContainerHeight,
                key: const Key("empty"),
                onFilterPressed: handleFilterPressed,
              ));

          lastTimestamp = profileCards[0].createdAt;
        }
        // 2건 있을 때 (이후 데이터 있음)
        else if (profileCards.length >= 2) {
          // 첫번째 데이터로 카드 추가
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            profileCard: profileCards[0],
            key: Key(profileCards[0].id!),
          ));
          // 앞뒤에 두번째 데이터 추가
          profileCardList.add(CardContainer(
            height: cardContainerHeight,
            profileCard: profileCards[1],
            key: Key(profileCards[1].id!),
          ));
          profileCardList.insert(
              0,
              CardContainer(
                height: cardContainerHeight,
                profileCard: profileCards[1],
                key: Key(profileCards[1].id!),
              ));

          lastTimestamp = profileCards[1].createdAt;
        }
        pageController = PageController(keepPage: false, initialPage: 1);
        pageController!.addListener(handlePageChanged);
      }
      // 조회된 데이터가 없을 때
      else {
        isLast = true;
        profileCardList.add(emptyContainer);
        pageController = PageController(keepPage: false, initialPage: 0);
      }
    }
    // 이후 페이지 로딩 일 때
    else {
      // 슬라이드 방향 좌우에 더미를 추가한다.
      if (direction == "right") {
        setState(() {
          profileCardList[pageController!.page!.toInt() - 1] = dummyContainer;
          profileCardList.add(dummyContainer);
          profileCardList.removeAt(0);
          pageController!.jumpToPage(1);
        });
      } else if (direction == "left") {
        setState(() {
          profileCardList[pageController!.page!.toInt() + 1] = dummyContainer;
          profileCardList.insert(0, dummyContainer);
          profileCardList.removeAt(3);
          pageController!.jumpToPage(1);
        });
      }
      // 다른 페이지부터는 다음 데이터만 로딩한다.
      final profileCards = await fetchProfileList(selectedGender,
          lastTimestamp: lastTimestamp,
          ageMin: filterLocal?.ageMin,
          ageMax: filterLocal?.ageMax);

      // 조회된 데이터가 있을 때
      if (profileCards.isNotEmpty) {
        final profileCard = CardContainer(
          height: cardContainerHeight,
          profileCard: profileCards[0],
          key: Key(profileCards[0].id!),
        );

        // 슬라이드 방향이 오른쪽이면
        if (direction == "right") {
          // 0 1(현재) 2
          // ->
          // 0 1(신규) 2(현재)
          // 0 1(신규) 2(현재) 3(신규)
          // 0(삭제) 1(신규) 2(현재) 3(신규)
          // 0(신규) 1(현재) 2(신규)

          // 왼쪽에 프로필 카드를 신규 카드로 변경
          profileCardList[pageController!.page!.toInt() - 1] = profileCard;
          // 오른쪽에 프로필 카드 추가
          profileCardList[pageController!.page!.toInt() + 1] = profileCard;
          // profileCardList.add(profileCard);
          // // 왼쪽에 가장 마지막 카드 삭제
          // profileCardList.removeAt(0);
          // // 1번 페이지로 고정
          // pageController!.jumpToPage(1);
        }
        // 슬라이드 방향이 왼쪽이면
        else if (direction == "left") {
          // 0 1(현재) 2
          // <-
          // 0(현재) 1(신규) 2
          // 0(신규) 1(현재) 2(신규) 3
          // 0(신규) 1(현재) 2(신규) 3(삭제)
          // 0(신규) 1(현재) 2(신규)

          // 오른쪽에 프로필 카드를 신규 카드로 변경
          profileCardList[pageController!.page!.toInt() + 1] = profileCard;
          // 왼쪽에 프로필카드 추가
          // profileCardList.insert(0, profileCard);
          profileCardList[0] = profileCard;
          // // 오른쪽에 가장 마지막 카드 삭제
          // profileCardList.removeAt(3);
          // // 1번 페이지로 고정
          // pageController!.jumpToPage(1);
        }

        lastTimestamp = profileCards[0].createdAt;
      }
      // 조회된 데이터가 없을 때
      else {
        isLast = true;
        // 슬라이드 방향이 오른쪽이면
        if (direction == "right") {
          // 0 1(현재) 2
          // ->
          // 0 1(빈) 2(현재)
          // 0 1(빈) 2(현재) 3(빈)
          // 0(삭제) 1(빈) 2(현재) 3(빈)
          // 0(빈) 1(현재) 2(빈)

          // 왼쪽에 프로필 카드를 신규 카드로 변경
          profileCardList[pageController!.page!.toInt() - 1] = emptyContainer;
          // 오른쪽에 프로필 카드 추가
          profileCardList.add(emptyContainer);
          // // 왼쪽에 가장 마지막 카드 삭제
          // profileCardList.removeAt(0);
          // // 1번 페이지로 고정
          // pageController!.jumpToPage(1);
        }
        // 슬라이드 방향이 왼쪽이면
        else if (direction == "left") {
          // 0 1(현재) 2
          // <-
          // 0(현재) 1(빈) 2
          // 0(빈) 1(현재) 2(빈) 3
          // 0(빈) 1(현재) 2(빈) 3(삭제)
          // 0(빈) 1(현재) 2(빈)

          // 오른쪽에 프로필 카드를 신규 카드로 변경
          profileCardList[pageController!.page!.toInt() + 1] = emptyContainer;
          // 왼쪽에 프로필카드 추가
          profileCardList.insert(0, emptyContainer);
          // // 오른쪽에 가장 마지막 카드 삭제
          // profileCardList.removeAt(3);
          // // 1번 페이지로 고정
          // pageController!.jumpToPage(1);
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
    setState(() {
      lastTimestamp = null;
      pageController = null;
      filterLocal = null;
      profileCardList.clear();
    });
    isLast = false;
    loadCard();
  }

  void handlePageChanged() {
    // log("current: ${currentPage.toDouble()}, page: ${pageController!.page!}");
    // 왼쪽으로 이동
    if (pageController!.page! == 0.0) {
      loadCard(direction: "left");
    }
    // 오른쪽으로 이동
    else if (pageController!.page! == 2.0) {
      loadCard(direction: "right");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
