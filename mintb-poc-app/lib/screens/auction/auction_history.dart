import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/profiles_collection.dart';
import 'package:mintb_poc_app/screens/auction/auction_bids.dart';
import 'package:mintb_poc_app/screens/auction/auction_live_detail.dart';

import '../../firebase/firestore/auctions_collection.dart';
import '../../utils.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionHistory extends StatefulWidget {
  const AuctionHistory({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionHistoryState();
  }
}

class _AuctionHistoryState extends State<AuctionHistory> {
  var currentIndex = 0;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      myAuctionSubscription;
  List<AuctionCollection> myAuctionList = [];

  List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      myAuctionLiveBidsSubscriptions = [];
  List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>
      myAuctionLiveViewSubscriptions = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? myBidsSubscription;
  List<StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>>
      myBidsAuctionLiveBidsSubscriptions = [];

  Timer? timer;
  var tick = 0;

  void listenMyAuctionsLiveBids(String auctionId) {
    // log(auctionId);
    final subscription =
        getSnapshotAuctionBids(auctionId).listen((event) async {
      final auctions =
          myAuctionList.where((element) => element.id == auctionId);
      if (auctions.isNotEmpty) {
        final auction = auctions.first;
        setState(() {
          if (event.docs.isNotEmpty) {
            auction.bids = event.docs
                .map((e) => AuctionBidCollection(e["amount"], id: e.id))
                .toList();
          } else {
            auction.bids = null;
          }
        });

        // 내 입찰 정보 조회이면 1위 입찰자 프로필 로딩
        if (currentIndex == 0) {
          if (auction.bids != null && auction.bids!.isNotEmpty) {
            final profile = await fetchProfile(id: auction.bids![0].id);
            // log("listen bidder");
            // log(profile!.nickname);
            setState(() {
              auction.bids![0].profile = profile;
            });
          }
        }
      }
    });
    myAuctionLiveBidsSubscriptions.add(subscription);
  }

  void listenMyAuctionsLiveViews(String auctionId) {
    final subscription = getSnapshotAuctionViews(auctionId).listen((event) {
      final auctions =
          myAuctionList.where((element) => element.id == auctionId);
      if (auctions.isNotEmpty) {
        final auction = auctions.first;
        setState(() {
          if (event.docs.isNotEmpty) {
            auction.views = event.docs.map((e) => e.id).toList();
          } else {
            auction.views = null;
          }
        });
      }
    });
    myAuctionLiveViewSubscriptions.add(subscription);
  }

  // 내 경매 응답 대기
  void listenMyAuctions() {
    myAuctionSubscription = getSnapshotMyAuctions().listen((event) async {
      if (event.docs.isNotEmpty) {
        List<AuctionCollection> auctions = [];
        for (final doc in event.docs) {
          final data = doc.data();
          final auction = AuctionCollection(
              data["profileId"], data["duration"], data["isLive"],
              id: doc.id,
              createdAt: data["createdAt"],
              endedAt: data["endedAt"]);
          auctions.add(auction);
        }
        setState(() {
          myAuctionList = [...auctions];
        });

        for (final auction in myAuctionList) {
          if (!auction.isLive) {
            // 라이브 상태가 아니면 조회와 입찰정보를 가져옴
            final views = await fetchAuctionViews(auction.id!);
            final bids = await fetchAuctionBids(auction.id!);
            setState(() {
              auction.views = views;
              auction.bids = bids;
            });
          } else {
            // 라이브 상태이면 조회와 입찰정보 리스너 추가
            listenMyAuctionsLiveBids(auction.id!);
            listenMyAuctionsLiveViews(auction.id!);
          }
        }
      } else {
        setState(() {
          myAuctionList.clear();
        });
      }
    });
  }

  // 내 입찰에 대한 라이브 경매 1건에 대한 응답 대기
  void listenMyBidsAuctionLive(String auctionId) {
    final subscription = getSnapshotAuction(auctionId).listen((event) {
      final auctions = myAuctionList.where((element) => element.id == event.id);
      if (auctions.isNotEmpty) {
        final auction = auctions.first;
        setState(() {
          auction.isLive = event.data()!["isLive"];
        });
      }
    });
    myBidsAuctionLiveBidsSubscriptions.add(subscription);
  }

  // 내 입찰 응답 대기
  void listenMyBids() {
    myBidsSubscription = getSnapshotMyBids().listen((event) async {
      if (event.docs.isNotEmpty) {
        List<AuctionCollection> auctions = [];
        for (var doc in event.docs) {
          // DocumentReference를 사용하여 부모 문서의 ID를 얻습니다.
          final auctionDoc = await doc.reference.parent.parent?.get();
          if (auctionDoc != null) {
            final data = auctionDoc.data()!;
            final auction = AuctionCollection(
                data["profileId"], data["duration"], data["isLive"],
                id: auctionDoc.id,
                createdAt: data["createdAt"],
                endedAt: data["endedAt"]);
            auction.profile = await fetchProfile(id: auction.profileId);

            auctions.add(auction);
          }
        }

        setState(() {
          myAuctionList = [...auctions];
        });

        for (final auction in myAuctionList) {
          if (!auction.isLive) {
            // log("-fetch");
            // 라이브 상태가 아니면 입찰정보를 가져옴
            final bids = await fetchAuctionBids(auction.id!);
            if (bids.isNotEmpty) {
              bids[0].profile = await fetchProfile(id: bids[0].id);
              // log("fetch bidder");
              // log(bids[0].profile!.nickname);
            }
            setState(() {
              auction.bids = bids;
            });
          } else {
            // log("-listen");
            // 라이브 상태이면 경매정보 리스터 추가
            listenMyBidsAuctionLive(auction.id!);
            // 라이브 상태이면 입찰정보 리스너 추가
            listenMyAuctionsLiveBids(auction.id!);
          }
        }
      } else {
        setState(() {
          myAuctionList.clear();
        });
      }
    });
  }

  // 경매 남은시간 처리
  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tick = timer.tick;
      });
    });
  }

  void cleanUp() {
    timer?.cancel();
    // 내 경매 관련 구독 리스너 해제
    myAuctionSubscription?.cancel();
    for (final sub in myAuctionLiveViewSubscriptions) {
      sub.cancel();
    }
    for (final sub in myAuctionLiveBidsSubscriptions) {
      sub.cancel();
    }
    // 내 입찰 관련 구독 리스너 해제
    myBidsSubscription?.cancel();
    for (final sub in myBidsAuctionLiveBidsSubscriptions) {
      sub.cancel();
    }
  }

  void handleTabChanged(int index) {
    cleanUp();
    if (index == 0) {
      listenMyBids();
    } else {
      listenMyAuctions();
      tickTimeRemaining();
    }

    setState(() {
      myAuctionList = [];
      currentIndex = index;
    });
  }

  void handleOpenBids(String auctionId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AuctionBids(auctionId),
      fullscreenDialog: true,
    ));
  }

  void handleOpenAuctionDetail(AuctionCollection auctionData) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AuctionLiveDetail(auctionData),
      fullscreenDialog: true,
    ));
  }

  @override
  void dispose() {
    cleanUp();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    handleTabChanged(currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1C1C26),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 바
              const CloseableTitledAppbar("경매 내역"),
              // 탭 메뉴
              Container(
                color: const Color(0xFF343434),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...[0, 1].map(
                          (e) => InkWell(
                              onTap: () {
                                handleTabChanged(e);
                              },
                              child: Container(
                                  width: 88,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: currentIndex == e
                                        ? const Color(0xFF3EDFCF)
                                        : const Color(0xFF343434),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1, color: Color(0xFF3EDFCF)),
                                      borderRadius: BorderRadius.only(
                                        topLeft: e == 1
                                            ? Radius.zero
                                            : const Radius.circular(8),
                                        topRight: e == 1
                                            ? const Radius.circular(8)
                                            : Radius.zero,
                                        bottomLeft: e == 1
                                            ? Radius.zero
                                            : const Radius.circular(8),
                                        bottomRight: e == 1
                                            ? const Radius.circular(8)
                                            : Radius.zero,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      e == 0 ? '내 입찰' : "내 경매",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: currentIndex == e
                                            ? const Color(0xFF343434)
                                            : const Color(0xFFB2BABB),
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ))),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              // 목록
              Expanded(
                  child: currentIndex == 0
                      // 내 입찰
                      ? Container(
                          color: const Color(0xFF343434),
                          child: ListView.builder(
                              itemCount: myAuctionList.length,
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                    onTap: () {
                                      handleOpenBids(myAuctionList[index].id!);
                                    },
                                    child: Container(
                                      height: 192,
                                      margin: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: index != 0 ? 20 : 0),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1C1C26),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Column(
                                        children: [
                                          // 경매 상태 및 프로필 정보
                                          Expanded(
                                              child: Stack(
                                            children: [
                                              // 경매 신청자 프로필
                                              Positioned(
                                                  left: 20,
                                                  top: 20,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // 프로필 이미지
                                                      Container(
                                                        width: 80,
                                                        height: 80,
                                                        decoration:
                                                            ShapeDecoration(
                                                          image: myAuctionList[
                                                                          index]
                                                                      .profile !=
                                                                  null
                                                              ? DecorationImage(
                                                                  image: NetworkImage(
                                                                      myAuctionList[index]
                                                                              .profile!
                                                                              .images[
                                                                          0]),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  alignment:
                                                                      Alignment
                                                                          .topCenter)
                                                              : null,
                                                          shape:
                                                              const OvalBorder(),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // 닉네임 (나이)
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 2),
                                                            child: Text(
                                                              myAuctionList[index]
                                                                          .profile !=
                                                                      null
                                                                  ? '${myAuctionList[index].profile?.nickname}  (${myAuctionList[index].profile?.age})'
                                                                  : "-",
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xFFD5DBDB),
                                                                fontSize: 16,
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Text(
                                                            index == 1
                                                                ? "Dancer, 174cm"
                                                                : 'Influencer, 168cm',
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFFD5DBDB),
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 0,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                              // 라이브 여부
                                              Positioned(
                                                  right: 14,
                                                  top: 14,
                                                  child: myAuctionList[index]
                                                          .isLive
                                                      ? Container(
                                                          width: 60,
                                                          height: 24,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: const Color(
                                                                0xFFEA4335),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Live',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ))
                                                      : Container(
                                                          width: 60,
                                                          height: 24,
                                                          decoration:
                                                              ShapeDecoration(
                                                            color: const Color(
                                                                0xFFB2BABB),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              '종료',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14,
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                height: 0,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                            ],
                                          )),
                                          // 입찰자 정보
                                          Container(
                                              height: 72,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 14),
                                              decoration: const ShapeDecoration(
                                                color: Color(0xFF3D3D54),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  image: myAuctionList[index].bids !=
                                                                              null &&
                                                                          myAuctionList[index]
                                                                              .bids!
                                                                              .isNotEmpty &&
                                                                          myAuctionList[index].bids![0].profile !=
                                                                              null
                                                                      ? DecorationImage(
                                                                          image: NetworkImage(myAuctionList[index].bids![0].profile!.images[
                                                                              0]),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          alignment:
                                                                              Alignment.topCenter)
                                                                      : null,
                                                                  shape:
                                                                      const OvalBorder(),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 16,
                                                              ),
                                                              Text(
                                                                myAuctionList[index].bids !=
                                                                            null &&
                                                                        myAuctionList[index]
                                                                            .bids!
                                                                            .isNotEmpty &&
                                                                        myAuctionList[index].bids![0].profile !=
                                                                            null
                                                                    ? myAuctionList[
                                                                            index]
                                                                        .bids![
                                                                            0]
                                                                        .profile!
                                                                        .nickname
                                                                    : "-",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xFFD5DBDB),
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  height: 0,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 29,
                                                          ),
                                                          Text(
                                                            myAuctionList[index]
                                                                            .bids !=
                                                                        null &&
                                                                    myAuctionList[
                                                                            index]
                                                                        .bids!
                                                                        .isNotEmpty
                                                                ? "${myAuctionList[index].bids![0].amount} m"
                                                                : "- m",
                                                            textAlign:
                                                                TextAlign.right,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF3EDFCF),
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              height: 0,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Positioned(
                                                      top: 7,
                                                      left: -7,
                                                      child: Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                            const ShapeDecoration(
                                                          color:
                                                              Color(0xFFFFB74D),
                                                          shape: OvalBorder(),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            '1st',
                                                            textAlign:
                                                                TextAlign.right,
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF1C1C26),
                                                              fontSize: 10,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              height: 0,
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ))
                                        ],
                                      ),
                                    ));
                              }))
                      // 내 경매
                      : Container(
                          color: const Color(0xFF343434),
                          child: ListView.builder(
                              itemCount: myAuctionList.length,
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                    onTap: () {
                                      handleOpenAuctionDetail(
                                          myAuctionList[index]);
                                    },
                                    child: Container(
                                      height: 113,
                                      margin: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: index != 0 ? 16 : 0),
                                      padding: const EdgeInsets.only(
                                          top: 14,
                                          left: 14,
                                          bottom: 14,
                                          right: 16),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF1C1C26),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // 라이브 여부 표시
                                              myAuctionList[index].isLive
                                                  ? Container(
                                                      width: 60,
                                                      height: 24,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: const Color(
                                                            0xFFEA4335),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Live',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 60,
                                                      height: 24,
                                                      decoration:
                                                          ShapeDecoration(
                                                        color: const Color(
                                                            0xFFB2BABB),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4)),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          '종료',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      )),
                                              // 최대 입찰 금액
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 2),
                                                  child: Text(
                                                    '${myAuctionList[index].bids != null ? myAuctionList[index].bids![0].amount : "-"} mint',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color(0xFF3EDFCF),
                                                      fontSize: 32,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          // 남은 시간 표시
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                myAuctionList[index].isLive ||
                                                        myAuctionList[index]
                                                                .endedAt ==
                                                            null
                                                    ? formatDuration(
                                                        myAuctionList[index]
                                                            .duration!
                                                            .toDate()
                                                            .difference(
                                                                DateTime.now()))
                                                    : formatDuration(
                                                        myAuctionList[index]
                                                            .endedAt!
                                                            .toDate()
                                                            .difference(
                                                                myAuctionList[
                                                                        index]
                                                                    .createdAt!
                                                                    .toDate())),
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Color(0xFFD5DBDB),
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '조회 ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFB2BABB),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: myAuctionList[index]
                                                                  .views !=
                                                              null
                                                          ? myAuctionList[index]
                                                              .views!
                                                              .length
                                                              .toString()
                                                          : "0",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF3EDFCF),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: '입찰 ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFB2BABB),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: myAuctionList[index]
                                                                  .bids !=
                                                              null
                                                          ? myAuctionList[index]
                                                              .bids!
                                                              .length
                                                              .toString()
                                                          : "0",
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF3EDFCF),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ));
                              }))),
              Container(
                height: 16,
                color: const Color(0xFF343434),
              )
            ],
          ),
        ),
      ),
    );
  }
}
