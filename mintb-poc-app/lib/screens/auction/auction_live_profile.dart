import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintb_poc_app/extensions.dart';
import 'package:mintb_poc_app/screens/auction/auction_bids.dart';
import 'package:mintb_poc_app/screens/card/sub/card_container.dart';
import 'package:mintb_poc_app/widgets/closeable_titled_appbar.dart';

import '../../firebase/auth.dart';
import '../../firebase/firestore/auction_collection.dart';
import '../../firebase/firestore/point_collections.dart';
import '../../firebase/firestore/profile_collection.dart';
import '../../utils.dart';

class AuctionLiveProfile extends StatefulWidget {
  const AuctionLiveProfile(
      {super.key, this.profileData, required this.auctionData});
  final AuctionCollection auctionData;
  final ProfileCollection? profileData;

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveProfileState();
  }
}

class _AuctionLiveProfileState extends State<AuctionLiveProfile> {
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

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionBidsSubscription;
  List<AuctionBidCollection> bidsList = [];
  PointCollection? _point;

  var maxBidAmountValue = 0;
  var bidsCount = 0;

  Timer? timer;
  var tick = 0;

  var showApplyForm = false;
  final TextEditingController amountController = TextEditingController();
  var validateMessage = "";

  var showComplete = false;
  var applyAmount = 0;
  var upperBidsNotification = true;

  var showDetail = false;
  var ranking = 0;

  void listenAuctionBids() {
    auctionBidsSubscription =
        getSnapshotAuctionBids(widget.auctionData.id!).listen((event) {
      setState(() {
        bidsCount = event.docs.length;
        if (event.docs.isNotEmpty) {
          maxBidAmountValue = event.docs.first.data()["amount"];
          bidsList.clear();
          for (var bid in event.docs) {
            bidsList
                .add(AuctionBidCollection(bid.data()["amount"], id: bid.id));
          }

          if (bidsList.isNotEmpty) {
            if (bidsList.where((e) => e.id == getUid()).isNotEmpty) {
              showDetail = true;
              ranking = bidsList
                      .indexOf(bidsList.firstWhere((e) => e.id == getUid())) +
                  1;
            } else {
              showDetail = false;
              ranking = 0;
            }
          }
        } else {
          maxBidAmountValue = 0;
        }
      });
    });
  }

  void handleOpenApplyBid() {
    setState(() {
      tickTimeRemaining();
      showApplyForm = true;
    });
  }

  void handleCloseApplyBid() {
    setState(() {
      timer?.cancel();
      showApplyForm = false;
      showComplete = false;
    });
  }

  void handleOpenBidsDetail() async {
    // 시간 계산 정지
    timer?.cancel();
    // 프로필 팝업  띄움
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AuctionBids(widget.auctionData.id!),
      fullscreenDialog: true,
    ));
    // 시간 계산 시작
    tickTimeRemaining();
  }

  void handleInputAmountPercent(int e) {
    if (_point != null) {
      final amount = _point!.mint.toDouble() * (e.toDouble() / 100.0);
      log(amount.toString());

      setState(() {
        amountController.text = amount.floor().toString();
      });

      handleInputAmountChanged(amountController.text);
    }
  }

  void handleInputAmountChanged(String value) {
    if (_point != null) {
      if (value == "") {
        setState(() {
          validateMessage = "";
        });
        return;
      }

      final inputAmount = value.replaceAll(",", "").toDouble().toInt();
      if (_point!.mint < inputAmount) {
        setState(() {
          validateMessage = "Not enough mint";
        });
        return;
      }

      if (inputAmount <= maxBidAmountValue) {
        setState(() {
          validateMessage = "현재 입찰가보나 더 높은 금액을 입력해야 합니다.";
        });
        return;
      }

      setState(() {
        validateMessage = "";
      });
      return;
    }

    setState(() {
      validateMessage = "Not enough mint";
    });
  }

  void handleRequestApplyBid() async {
    if (amountController.text.isEmpty) {
      validateMessage = "Please enter the amount of mints.";
      return;
    }

    if (validateMessage.isNotEmpty) {
      return;
    }

    final amount = amountController.text.replaceAll(",", "").toDouble().toInt();
    await createAuctionBid(widget.auctionData.id!, amount);
    await loadPoint();
    setState(() {
      amountController.text = "";
      applyAmount = amount;
      showApplyForm = false;
      showComplete = true;
    });
  }

  void handelToggleUpperBidsNotification() {
    setState(() {
      upperBidsNotification = !upperBidsNotification;
    });
  }

  void tickTimeRemaining() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        tick = timer.tick;
      });
    });
  }

  Future<void> loadPoint() async {
    final point = await fetchPoints();
    if (point != null) {
      setState(() {
        _point = point;
      });
    }
  }

  @override
  void dispose() {
    auctionBidsSubscription?.cancel();
    timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenAuctionBids();
    loadPoint();
  }

  @override
  Widget build(BuildContext context) {
    setCardContainerHeight(context);
    return Scaffold(
        body: Container(
            color: const Color(0xFF1C1C26),
            child: SafeArea(
                child: Stack(children: [
              // 상단 바
              CloseableTitledAppbar(widget.profileData!.nickname),
              // 프로필
              Row(
                children: [
                  Expanded(
                      child: Container(
                          color: const Color(0xFF343434),
                          margin: const EdgeInsets.only(top: 48 + 16),
                          padding: const EdgeInsets.only(
                              left: 18, right: 18, bottom: 0),
                          child: CardContainer(
                              profileData: widget.profileData,
                              height: cardContainerHeight))),
                ],
              ),
              // 입찰하기 버튼
              !showDetail
                  ? Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 74,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(28, 28, 38, 0.70),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.50),
                              blurRadius: 2.0,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: handleOpenApplyBid,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EDFCF), // 배경 색상
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 모서리 둥글기
                            ),
                            textStyle: const TextStyle(
                              fontFamily: 'Pretendard', // 폰트
                              fontWeight: FontWeight.w700, // 굵기
                              fontSize: 16, // 폰트 크기
                            ),
                          ),
                          child: const Text(
                            '입찰하기',
                            style: TextStyle(
                              color: Color(0xFF343434), // 텍스트 색상
                              height: 0, // 텍스트 높이 (line height)
                            ),
                          ),
                        ),
                      ))
                  : Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width, // 100% width
                        height: 74,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(62, 223, 207,
                              0.5), // Semi-transparent background color
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(
                                  0, 0, 0, 0.5), // Shadow color with opacity
                              offset: Offset(0, -2), // x, y offset of shadow
                              blurRadius: 2.0, // Blur radius of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF343434), // Background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: handleOpenBidsDetail,
                            child: const Text(
                              '입찰 상세 내역',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF3EDFCF),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            )),
                      )),
              // 최고 입찰금액
              !showDetail
                  ? Positioned(
                      bottom: 22,
                      right: 27,
                      child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF2DB3A6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Center(
                            child: Text(
                              '$maxBidAmountValue +',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFFB74D),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          )))
                  : Positioned(
                      right: 27,
                      bottom: 22,
                      child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFB74D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Center(
                            child: Text(
                              '현재 $ranking 등',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ))),
              // 입찰신청 폼 및 완료화면
              showApplyForm || showComplete
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: const Color.fromRGBO(28, 28, 38, 0.50),
                      child: Column(
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: handleCloseApplyBid,
                          )),
                          // 현재 입찰정보
                          showApplyForm
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 163,
                                  padding: const EdgeInsets.only(
                                      top: 20, left: 16, right: 16),
                                  decoration: ShapeDecoration(
                                    color: Colors.black
                                        .withOpacity(0.6000000238418579),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '현재 입찰가',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFFD5DBDB),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          Text(
                                            '$maxBidAmountValue mint',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFF3EDFCF),
                                              fontSize: 32,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '남은 시간',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFFD5DBDB),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          Text(
                                            formatDuration(widget
                                                .auctionData.duration!
                                                .toDate()
                                                .difference(DateTime.now())),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFFFFB74D),
                                              fontSize: 20,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                              onTap: handleOpenBidsDetail,
                                              child: Text(
                                                '입찰 상세 내역($bidsCount)',
                                                style: const TextStyle(
                                                  color: Color(0xFF949494),
                                                  fontSize: 16,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Color(0xFF949494),
                                                  height: 0,
                                                ),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          // 입찰 금액 입력폼
                          showApplyForm
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 243,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 16),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF1C1C26)),
                                  child: Column(
                                    children: [
                                      // 퍼센트 선택 버튼목록
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [10, 30, 50, 100]
                                            .map((e) => Expanded(
                                                child: Container(
                                                    height: 32,
                                                    margin: e == 10
                                                        ? EdgeInsets.zero
                                                        : const EdgeInsets.only(
                                                            left: 12),
                                                    decoration: ShapeDecoration(
                                                      color: const Color(
                                                          0xFF343434),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                    ),
                                                    child: InkWell(
                                                        onTap: () {
                                                          handleInputAmountPercent(
                                                              e);
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            '+$e %',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color: Color(
                                                                  0xFF3EDFCF),
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              height: 0,
                                                            ),
                                                          ),
                                                        )))))
                                            .toList(),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      // 입력폼
                                      SizedBox(
                                        height: 47,
                                        child: TextField(
                                          controller: amountController,
                                          onChanged: handleInputAmountChanged,
                                          textAlign: TextAlign.right,
                                          style: const TextStyle(
                                            color: Color(0xFFE5E5E5),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                          ),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color(0xFF343434),
                                            hintText: "입찰가",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFF888888),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ), // 배경색
                                            contentPadding:
                                                const EdgeInsets.all(
                                                    12), // 내부 여백 설정 (선택 사항)
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors
                                                      .black), // 활성화 상태 테두리
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: Colors
                                                      .black), // 포커스 상태 테두리
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              signed: false, decimal: false),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      // 입력값 검증 메시지
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            validateMessage,
                                            style: const TextStyle(
                                              color: Color(0xFFDE5854),
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w300,
                                              height: 0,
                                            ),
                                          )
                                        ],
                                      ),
                                      const Expanded(child: SizedBox.expand()),
                                      // 입찰신청 버튼
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: handleRequestApplyBid,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFF3EDFCF), // 배경색
                                            shape: RoundedRectangleBorder(
                                              // 테두리 둥글기
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text(
                                            '입찰신청',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF343434),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ), // 버튼 텍스트
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          // 입찰 완료
                          showComplete
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 322,
                                  padding: const EdgeInsets.only(
                                      top: 24, left: 16, right: 16, bottom: 20),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1C1C26),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '입찰 완료',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Color(0xFF3EDFCF),
                                          fontSize: 24,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 93,
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            left: 16,
                                            right: 23,
                                            bottom: 18),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF343434),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  '입찰가',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFFD5DBDB),
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Text(
                                                  '$applyAmount mint',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFF3EDFCF),
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  '경매 종료 일시',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Color(0xFFD5DBDB),
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                ),
                                                Text(
                                                  formatDateTime(widget
                                                      .auctionData.duration!
                                                      .toDate()),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Color(0xFFFFB74D),
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 31,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            '상위 입찰 시, 알림 받기',
                                            style: TextStyle(
                                              color: Color(0xFFD5DBDB),
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap:
                                                handelToggleUpperBidsNotification,
                                            child: Image.asset(
                                              upperBidsNotification
                                                  ? "assets/toggle_on.png"
                                                  : "assets/toggle_off.png",
                                              width: 64,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 23,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xFF3EDFCF)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          fixedSize: MaterialStateProperty.all(
                                              Size(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  50)), // Sets the button size
                                        ),
                                        onPressed: handleCloseApplyBid,
                                        child: const Text(
                                          '확인',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF343434),
                                            fontSize: 16,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ))
                              : const SizedBox.shrink()
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ]))));
  }
}
