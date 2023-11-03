import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auction/auction_request_live.dart';

import '../../firebase/firestore/auction_requests_collection.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionRequestPending extends StatefulWidget {
  const AuctionRequestPending(this.auctionRequestId, {super.key});
  final String auctionRequestId;

  @override
  State<StatefulWidget> createState() {
    return _AuctionRequestPendingState();
  }
}

class _AuctionRequestPendingState extends State<AuctionRequestPending> {
  Timer? timer;
  var tick = 0;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      auctionSubscription;
  listenAuctionRequest() {
    auctionSubscription =
        getSnapshotAuctionRequest(widget.auctionRequestId).listen((event) {
      final auctionData = event.data();
      if (auctionData != null && auctionData.isNotEmpty) {
        bool? isConfirm = auctionData["isConfirm"];
        if (isConfirm != null && isConfirm) {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AuctionRequestLive(widget.auctionRequestId),
              fullscreenDialog: true,
            ));
          }
        }
      }
    });
  }

  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      timer.cancel();
      confirmAuctionRequest(widget.auctionRequestId);
    });
  }

  void handleCancel() async {
    await removeAuctionRequest(widget.auctionRequestId);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    auctionSubscription?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenAuctionRequest();
    tickTimeRemaining();
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
                  const CloseableTitledAppbar("승인 대기"),
                  Expanded(
                      child: Container(
                          color: const Color(0xFF343434),
                          child: const Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '승인 대기중입니다...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFFB74D),
                                  fontSize: 32,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                '관리자가 프로필을 체크하고 있습니다.\n30분 ~ 최대 하루 정도 소요될 수 있어요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFD5DBDB),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              )
                            ],
                          )))),
                ]),
                Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                        onTap: handleCancel,
                        child: Container(
                          width: 64,
                          height: 32,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF343434),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Center(
                            child: Text(
                              '취소',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF3DDFCE),
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
