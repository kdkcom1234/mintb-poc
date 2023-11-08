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
              Container(
                color: const Color(0xFF343434),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 24, top: 40),
                          child: Text(
                            '경매매칭 참여 혜택을 \n알려드려요',
                            style: TextStyle(
                              color: Color(0xFFFFB74D),
                              fontSize: 28,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                        ),
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
                                  "assets/puzzle_icon.png",
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
                                    '진정성 있는 유저와 매칭',
                                    style: TextStyle(
                                      color: Color(0xFF3EDFCF),
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
                                    '가벼운 호감이 아니라, 당신에게 진심인\n단 1명의 이성을 소개시켜드릴께요',
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
                                padding: const EdgeInsets.only(
                                    top: 14, bottom: 13, left: 7, right: 5.22),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: OvalBorder(),
                                ),
                                child: Image.asset(
                                  "assets/rewards_icon.png",
                                  width: 47.78,
                                  height: 33,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '풍부한 보상',
                                    style: TextStyle(
                                      color: Color(0xFF3EDFCF),
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
                                    '많은 관심을 받을 수록 더 많은 POP score와\nmint를 획득할 수 있있어요',
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
                                padding: const EdgeInsets.all(0),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: OvalBorder(),
                                ),
                                child: Image.asset(
                                  "assets/mtb_ticker_icon.png",
                                  width: 31.96,
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
                                    '블록체인 기반 토큰 보상',
                                    style: TextStyle(
                                      color: Color(0xFF3EDFCF),
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
                                    '높은 관심을 받는 분들께 수익 실현가능한\n\$MTB를 드릴께요',
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
                  ],
                ),
              ),
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
