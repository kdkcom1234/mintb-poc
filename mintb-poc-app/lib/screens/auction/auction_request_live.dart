import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auction/auction_live_detail.dart';

import '../../firebase/firestore/auction_requests_collection.dart';
import '../../firebase/firestore/auctions_collection.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionRequestLive extends StatefulWidget {
  const AuctionRequestLive(this.auctionRequestId, {super.key});
  final String auctionRequestId;

  @override
  State<StatefulWidget> createState() {
    return _AuctionRequestLiveState();
  }
}

class _AuctionRequestLiveState extends State<AuctionRequestLive> {
  var loading = false;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? auctionSubscription;
  listenAuctionRequest() {
    auctionSubscription =
        getSnapshotAuctionRequestLive(widget.auctionRequestId).listen((event) {
      if (event.docs.isNotEmpty) {
        final data = event.docs.first.data();
        String auctionId = event.docs.first.id;
        final auctionData = AuctionCollection(
            data["profileId"], data["duration"], data["isLive"],
            id: auctionId, createdAt: data["createdAt"]);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuctionLiveDetail(auctionData),
          fullscreenDialog: true,
        ));
      }
    });
  }

  void handleLive() async {
    listenAuctionRequest();
    setState(() {
      loading = true;
    });
    await liveAuctionRequest(widget.auctionRequestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF1C1C26),
            child: SafeArea(
                child: Column(children: [
              // 상단 바
              const CloseableTitledAppbar("경매 시작하기"),
              Container(
                  color: const Color(0xFF343434),
                  child: Column(children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24, top: 40),
                          child: Text(
                            '시작 전 알려드릴게 있어요',
                            style: TextStyle(
                              color: Color(0xFF3EDFCF),
                              fontSize: 28,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(15),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: OvalBorder(),
                                ),
                                child: Image.asset(
                                  "assets/24hours_icon.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '시작 후 24시간 뒤 종료됩니다.',
                                    style: TextStyle(
                                      color: Color(0xFFFFB74D),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '경매는 시작버튼을 누른 뒤 24시간 동안 진행\n되고, 24시간이 지나면 자동으로 종료되요.',
                                    style: TextStyle(
                                      color: Color(0xFFD5DBDB),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(10),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: OvalBorder(),
                                ),
                                child: Image.asset(
                                  "assets/guard_icon.png",
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '걱정마세요',
                                    style: TextStyle(
                                      color: Color(0xFFFFB74D),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '지인이나, 친구 등 나를 아는 사람들과 이미\n매칭됬던 사람들에게는 노출되지 않습니다.',
                                    style: TextStyle(
                                      color: Color(0xFFD5DBDB),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                padding: const EdgeInsets.all(15),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: OvalBorder(),
                                ),
                                child: Image.asset(
                                  "assets/heart_chat_icon.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '경매 종료 후, 바로 매칭',
                                    style: TextStyle(
                                      color: Color(0xFFFFB74D),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    '경매가 종료되면 낙찰된 유저와 바로 매칭되며,\n채팅방이 개설됩니다.',
                                    style: TextStyle(
                                      color: Color(0xFFD5DBDB),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ])),
              Expanded(
                  child: Container(
                color: const Color(0xFF343434),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(Size(
                                    MediaQuery.of(context).size.width - 32,
                                    48)),
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF3EDFCF)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              onPressed: handleLive,
                              child: !loading
                                  ? const Text(
                                      '경매 시작하기',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF343434),
                                        fontSize: 16,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()),
                            ))
                      ],
                    )
                  ],
                ),
              )),
            ]))));
  }
}
