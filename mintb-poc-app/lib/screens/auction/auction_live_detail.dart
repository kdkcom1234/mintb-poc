import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/extensions.dart';
import 'package:mintb_poc_app/firebase/firestore/auctions_collection.dart';
import 'package:mintb_poc_app/utils.dart';

import '../../firebase/firestore/profiles_collection.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionLiveDetail extends StatefulWidget {
  const AuctionLiveDetail(this.auctionData, {super.key});
  final AuctionCollection auctionData;

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveDetailState();
  }
}

class _AuctionLiveDetailState extends State<AuctionLiveDetail> {
  Timer? timer;
  var tick = 0;
  var maxBidAmountValue = 0;

  // MTB
  // maxBidAmount / 1350;
  double mtbAmountValue() {
    return (maxBidAmountValue / 1350.0).truncateToDecimalPlaces(4);
  }

  var viewCount = 0;

  // POP score
  // 최대입찰mint * 3 + 조회수 * 10
  // (maxBidAmountValue * 3 + viewCount * 10)
  int popScore() {
    return maxBidAmountValue * 3 + viewCount * 10;
  }

  var bidsCount = 0;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionViewSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionBidsSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      auctionStatusSubscription;
  List<AuctionBidCollection> bidsList = [];
  final List<ProfileCollection> profileList = [];

  // 1: 종료, 2: 보상획득 요청, 3: 보상획드 완료
  var status = 0;

  // 경매 상태 업데이트 대기
  void listenAuctionStatus() {
    auctionStatusSubscription =
        getSnapshotAuction(widget.auctionData.id!).listen((event) {
      final data = event.data();
      if (data == null || data.isEmpty) {
        return;
      }
      if (data["status"] == null) {
        status = 0;
      } else {
        setState(() {
          status = data["status"];
        });
      }
      if (status == 3) {
        displayRewardsDialog(data["pop"], data["mint"], data["mtb"]);
      }
    });
  }

  // 경매 조회수 업데이트 대기
  void listenAuctionViews() {
    auctionViewSubscription =
        getSnapshotAuctionViews(widget.auctionData.id!).listen((event) {
      if (event.docs.isNotEmpty) {
        setState(() {
          viewCount = event.docs.length;
        });
      }
    });
  }

  // 경매 입찰 정보 업데이트 대기
  void listenAuctionBids() {
    auctionBidsSubscription =
        getSnapshotAuctionBids(widget.auctionData.id!).listen((event) async {
      setState(() {
        log("--bid updated--");
        bidsCount = event.docs.length;
        if (event.docs.isNotEmpty) {
          maxBidAmountValue = event.docs.first.data()["amount"];
          bidsList.clear();
          for (var bid in event.docs) {
            bidsList
                .add(AuctionBidCollection(bid.data()["amount"], id: bid.id));
          }
        }
      });

      // 입찰정보의 프로필 목록 조회
      final profiles =
          await fetchProfilesByIds(bidsList.map((e) => e.id!).toList());
      setState(() {
        profileList.clear();
        for (final profile in profiles) {
          profileList.add(profile);
        }
      });
    });
  }

  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tick = timer.tick;
        // log(tick.toString());
      });

      if (tick == 5 && status == 0) {
        endAuction(widget.auctionData.id!);
      }
    });
  }

  // 경매 상태별 남은 시간/종료 여부 표시
  String displayStatus() {
    if (status == 1 || status == 2) {
      return "경매 종료";
    }

    if (status == 9) {
      return "경매 중지";
    }

    return formatDuration(
        widget.auctionData.duration!.toDate().difference(DateTime.now()));
  }

  Widget displaySpacing() {
    if ([1, 2].contains(status)) {
      return const SizedBox(
        height: 26,
      );
    }

    if (status == 3) {
      return const SizedBox(
        height: 10,
      );
    }

    return const SizedBox(
      height: 30,
    );
  }

  // 조회, 입찰 횟수, 보상 획득하기 버튼 표시
  Widget displayRewardActionStatus() {
    // 경매 종료
    if (status == 1) {
      return ElevatedButton(
        onPressed: handleRequestRewards,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB74D),
          minimumSize: Size(MediaQuery.of(context).size.width, 48),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          '보상 획득하기',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF343434),
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
    // 보상 획득 요청
    if (status == 2) {
      return ElevatedButton(
          onPressed: handleRequestRewards,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB74D),
            minimumSize: Size(MediaQuery.of(context).size.width, 48),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          ));
    }
    // 보상 획득 완료
    if (status == 3) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 조회수
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '조회 ',
                style: TextStyle(
                  color: Color(0xFFB2BABB),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              TextSpan(
                text: viewCount.toString(),
                style: const TextStyle(
                  color: Color(0xFF3EDFCF),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: '입찰 ',
                style: TextStyle(
                  color: Color(0xFFB2BABB),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
              TextSpan(
                text: bidsCount.toString(),
                style: const TextStyle(
                  color: Color(0xFF3EDFCF),
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void handleStop() async {}

  void handleRequestRewards() async {
    await requestAuctionRewards(widget.auctionData.id!);
  }

  void displayRewardsDialog(int pop, int mint, double mtb) {
    log(status.toString());
    log("$pop $mint, $mtb");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          elevation: 0, // 기본 그림자 제거
          backgroundColor: Colors.transparent, // 백그라운드 색상 설정
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // 원하는 너비
            height: MediaQuery.of(context).size.height, // 원하는 높이
            child: Center(
              child: Container(
                width: 300,
                height: 363,
                padding: const EdgeInsets.only(
                    top: 24, left: 16, right: 16, bottom: 16),
                decoration: ShapeDecoration(
                  color: const Color(0xFF1C1C26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      '보상 획득 완료',
                      style: TextStyle(
                        color: Color(0xFF25ECD7),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(7.33),
                              decoration: const ShapeDecoration(
                                color: Color(0xFF343434),
                                shape: OvalBorder(),
                              ),
                              child: Image.asset(
                                "assets/pop_score_icon.png",
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              'POP scroe',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFB2BABB),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        Text(
                          pop.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF3EDFCF),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(14),
                              decoration: const ShapeDecoration(
                                color: Color(0xFF343434),
                                shape: OvalBorder(),
                              ),
                              child: Image.asset(
                                "assets/mint_icon.png",
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              'mint',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFB2BABB),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        Text(
                          mint.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF3EDFCF),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.all(0),
                              decoration: const ShapeDecoration(
                                color: Color(0xFF343434),
                                shape: OvalBorder(),
                              ),
                              child: Image.asset(
                                "assets/mtb_ticker_icon.png",
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const Text(
                              '\$MTB',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFB2BABB),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        Text(
                          mtb.toString(),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF3EDFCF),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xFF25ECD7), // Button background color// Button text color
                        minimumSize:
                            const Size(double.infinity, 48), // Button size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Button corner radius
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Text(
                        '확인',
                        style: TextStyle(
                          color: Color(0xFF343434),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    auctionViewSubscription?.cancel();
    auctionBidsSubscription?.cancel();
    auctionStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tickTimeRemaining();
    listenAuctionViews();
    listenAuctionBids();
    listenAuctionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF1C1C26),
            child: SafeArea(
                child: Stack(
              children: [
                Column(children: [
                  // 상단 바
                  const CloseableTitledAppbar("경매 상세페이지"),
                  Expanded(
                      child: Container(
                          color: const Color(0xFF343434),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12, right: 16, left: 16),
                            child: Column(
                              children: [
                                // 남은 시간
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                32,
                                        height: 40,
                                        margin:
                                            const EdgeInsets.only(bottom: 26),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF1C1C26),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            displayStatus(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFF3EDFCF),
                                              fontSize: 20,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 26,
                                ),
                                // 포인트 목록
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // POP
                                      Column(
                                        children: [
                                          Container(
                                            width: 72,
                                            height: 72,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 11, vertical: 11),
                                            decoration: const ShapeDecoration(
                                              color: Color(0xFF1C1C26),
                                              shape: OvalBorder(),
                                            ),
                                            child: Image.asset(
                                              "assets/pop_score_icon.png",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            popScore() == 0
                                                ? "-"
                                                : popScore().toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color(0xFF3EDFCF),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          const Text(
                                            'POP score',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFFB2BABB),
                                              fontSize: 12,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                      // Mint
                                      Column(
                                        children: [
                                          Container(
                                            width: 72,
                                            height: 72,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 16),
                                            decoration: const ShapeDecoration(
                                              color: Color(0xFF1C1C26),
                                              shape: OvalBorder(),
                                            ),
                                            child: Image.asset(
                                              "assets/mint_icon.png",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            maxBidAmountValue == 0
                                                ? "-"
                                                : maxBidAmountValue.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color(0xFF3EDFCF),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          const Text(
                                            'mint',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFFB2BABB),
                                              fontSize: 12,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                      // MTB
                                      Column(
                                        children: [
                                          Container(
                                            width: 72,
                                            height: 72,
                                            decoration: const ShapeDecoration(
                                              color: Color(0xFF1C1C26),
                                              shape: OvalBorder(),
                                            ),
                                            child: Image.asset(
                                              "assets/mtb_ticker_icon.png",
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            mtbAmountValue() == 0
                                                ? "-"
                                                : mtbAmountValue().toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Color(0xFF3EDFCF),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          const Text(
                                            '\$MTB',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Color(0xFFB2BABB),
                                              fontSize: 12,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                displaySpacing(),
                                // 조회, 입찰, 보상 획득하기 버튼
                                displayRewardActionStatus(),
                                SizedBox(
                                  height: status >= 1 ? 16 : 8,
                                ),
                                // 최고 입찰자
                                status >= 1
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 364,
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        margin:
                                            const EdgeInsets.only(bottom: 19),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF1C1C26),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 56.84,
                                            ),
                                            // 프로필이미지, 1순위
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 99.73,
                                                  decoration: ShapeDecoration(
                                                    image: profileList
                                                            .isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                profileList[0]
                                                                    .images[0]),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                    shape: const OvalBorder(),
                                                  ),
                                                ),
                                                Positioned(
                                                    left: -3,
                                                    top: -5.98,
                                                    child: Container(
                                                        width: 33,
                                                        height: 33,
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
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              height: 0,
                                                            ),
                                                          ),
                                                        )))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 11.97,
                                            ),
                                            const Text(
                                              'Kevin',
                                              style: TextStyle(
                                                color: Color(0xFFD5DBDB),
                                                fontSize: 24,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 11.97,
                                            ),
                                            Text(
                                              '$maxBidAmountValue m',
                                              textAlign: TextAlign.right,
                                              style: const TextStyle(
                                                color: Color(0xFF3EDFCF),
                                                fontSize: 24,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 31.65,
                                            ),
                                            Container(
                                                width: double.infinity,
                                                height: 48,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0xFF3EDFCF),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    '채팅하기',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xFF1C1C26),
                                                      fontSize: 16,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0,
                                                    ),
                                                  ),
                                                )),
                                            const SizedBox(
                                              height: 16,
                                            ),
                                            const Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '연애온도에 따라 최대 ',
                                                    style: TextStyle(
                                                      color: Color(0xFFD5DBDB),
                                                      fontSize: 12,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '2000 MTB',
                                                    style: TextStyle(
                                                      color: Color(0xFF3EDFCF),
                                                      fontSize: 12,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' 획득 가능',
                                                    style: TextStyle(
                                                      color: Color(0xFFD5DBDB),
                                                      fontSize: 12,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                // 입찰 목록
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: status >= 1
                                            ? bidsList.length - 1
                                            : bidsList.length,
                                        itemBuilder: (ctx, index) => Stack(
                                              children: [
                                                // 리스트 박스
                                                Container(
                                                  margin: index != 0
                                                      ? const EdgeInsets.only(
                                                          top: 16)
                                                      : EdgeInsets.zero,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 78,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 14),
                                                  decoration: ShapeDecoration(
                                                    color:
                                                        const Color(0xFF1C1C26),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            height: 50,
                                                            decoration:
                                                                ShapeDecoration(
                                                              image: profileList
                                                                      .isNotEmpty
                                                                  ? DecorationImage(
                                                                      image: NetworkImage(profileList
                                                                          .firstWhere((e) =>
                                                                              e.id! ==
                                                                              bidsList[status >= 1 ? index + 1 : index].id)
                                                                          .images[0]),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )
                                                                  : null,
                                                              shape:
                                                                  const OvalBorder(),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 16,
                                                          ),
                                                          Text(
                                                            profileList
                                                                    .isNotEmpty
                                                                ? profileList
                                                                    .firstWhere((e) =>
                                                                        e.id! ==
                                                                        bidsList[status >= 1
                                                                                ? index + 1
                                                                                : index]
                                                                            .id)
                                                                    .nickname
                                                                : "",
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
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${bidsList[status >= 1 ? index + 1 : index].amount} m',
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // 1순위 표시 마커
                                                status == 0 && index == 0
                                                    ? Positioned(
                                                        top: 7,
                                                        left: 7,
                                                        child: Container(
                                                            width: 22,
                                                            height: 22,
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 1),
                                                            decoration:
                                                                const ShapeDecoration(
                                                              color: Color(
                                                                  0xFFFFB74D),
                                                              shape:
                                                                  OvalBorder(),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                '1st',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style:
                                                                    TextStyle(
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
                                                            )),
                                                      )
                                                    : const SizedBox.shrink()
                                              ],
                                            )))
                              ],
                            ),
                          ))),
                ]),
                // 중지 버튼
                Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                        onTap: handleStop,
                        child: Container(
                          width: 64,
                          height: 32,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF3EDFCF),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              '중지',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF343434),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ))),
              ],
            ))));
  }
}
