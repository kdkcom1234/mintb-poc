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
  var viewCount = 0;
  var bidsCount = 0;
  var maxBidAmountValue = 0;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionViewSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionBidsSubscription;
  List<AuctionBidCollection> bidsList = [];
  final List<ProfileCollection> profileList = [];

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

  void handleStop() async {}

  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tick = timer.tick;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    auctionViewSubscription?.cancel();
    auctionBidsSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tickTimeRemaining();
    listenAuctionViews();
    listenAuctionBids();
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
                                            formatDuration(widget
                                                .auctionData.duration!
                                                .toDate()
                                                .difference(DateTime.now())),
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
                                            maxBidAmountValue == 0 &&
                                                    viewCount == 0
                                                ? "-"
                                                : (maxBidAmountValue * 3 +
                                                        viewCount * 10)
                                                    .toString(),
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
                                            'POP scroe',
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
                                            maxBidAmountValue == 0
                                                ? "-"
                                                : (maxBidAmountValue / 1350.0)
                                                    .truncateToDecimalPlaces(4)
                                                    .toString(),
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
                                const SizedBox(
                                  height: 30,
                                ),
                                // 조회, 입찰
                                Row(
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
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: bidsList.length,
                                        itemBuilder: (ctx, index) => Stack(
                                              children: [
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
                                                                              bidsList[index].id)
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
                                                                        bidsList[index]
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
                                                            '${bidsList[index].amount} m',
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
                                                index == 0
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
