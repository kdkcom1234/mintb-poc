import 'dart:developer';

import 'package:flutter/material.dart';

import '../../widgets/closeable_titled_appbar.dart';

class AuctionLiveDetail extends StatefulWidget {
  const AuctionLiveDetail(this.auctionId, {super.key});
  final String auctionId;

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveDetailState();
  }
}

class _AuctionLiveDetailState extends State<AuctionLiveDetail> {
  void handleStop() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.auctionId);
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
                          child: const Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Row()],
                          )))),
                ]),
                Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                        onTap: handleStop,
                        child: Container(
                          width: 64,
                          height: 32,
                          decoration: ShapeDecoration(
                            color: Color(0xFF3EDFCF),
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
