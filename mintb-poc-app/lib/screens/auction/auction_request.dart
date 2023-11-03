import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/auction/auction_request_pending.dart';

import '../../firebase/firestore/auction_requests_collection.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionRequest extends StatefulWidget {
  const AuctionRequest({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionRequestState();
  }
}

class _AuctionRequestState extends State<AuctionRequest> {
  void handleCreateRequest() async {
    String auctionRequestId = await createAuctionRequest();

    if (context.mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => AuctionRequestPending(auctionRequestId),
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
              const CloseableTitledAppbar("경매신청"),
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
                              onPressed: handleCreateRequest,
                              child: const Text(
                                '신청하기',
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
