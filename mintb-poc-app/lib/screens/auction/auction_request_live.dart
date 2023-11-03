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
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? auctionSubscription;
  listenAuctionRequest() {
    auctionSubscription =
        getSnapshotAuctionRequestLive(widget.auctionRequestId).listen((event) {
      if (event.docs.isNotEmpty) {
        final auctionData = event.docs.first;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AuctionLiveDetail(auctionData.id),
          fullscreenDialog: true,
        ));
      }
    });
  }

  void handleLive() async {
    await setAuctionRequestLive(widget.auctionRequestId);

    if (context.mounted) {
      await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuctionLiveDetail(widget.auctionRequestId),
        fullscreenDialog: true,
      ));
    }
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
                              child: const Text(
                                '경매 시작하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF343434),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              )),
            ]))));
  }
}
