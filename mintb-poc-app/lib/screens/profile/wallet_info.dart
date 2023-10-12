import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintb_poc_app/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../onchain/web3_integration.dart';

class WalletInfo extends StatefulWidget {
  const WalletInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WalletInfoState();
  }
}

class _WalletInfoState extends State<WalletInfo> {
  final address = walletAddress().toString().shortenFromAddress();

  var mtbAmount = "0";
  var mtbPrice = 1;

  var bnbAmount = "0";
  var bnbPrice = 200;

  late Timer _timer;

  String mtbValue() {
    return (double.parse(mtbAmount.replaceAll(",", "")) * mtbPrice)
        .truncateToDecimalPlaces(2)
        .toString()
        .formatNumberWithCommas();
  }

  String bnbValue() {
    return (double.parse(bnbAmount.replaceAll(",", "")) * bnbPrice)
        .truncateToDecimalPlaces(2)
        .toString()
        .formatNumberWithCommas();
  }

  @override
  void initState() {
    super.initState();

    setNativeBalance();
    setTokenBalance();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setNativeBalance();
      setTokenBalance();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> setNativeBalance() async {
    final result = await getNativeBalance();
    setState(() {
      bnbAmount = double.parse(result)
          .truncateToDecimalPlaces(4)
          .toString()
          .formatNumberWithCommas();
    });
  }

  Future<void> setTokenBalance() async {
    final result = await getTokenBalance();
    setState(() {
      mtbAmount = double.parse(result)
          .truncateToDecimalPlaces(4)
          .toString()
          .formatNumberWithCommas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
      child: Column(
        children: [
          // 주소
          Container(
            height: 48,
            decoration: ShapeDecoration(
              color: const Color(0xFF484848),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFDADADA),
                      fontSize: 16,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: walletAddress().toString()));
                      },
                      child: Text(
                        address,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF3DDFCE),
                          fontSize: 16,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ))
                ],
              ),
            ),
          ),
          // 기능 목록
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 전송
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            "/profile/wallet/send-form",
                            arguments: mtbAmount);
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.only(
                            top: 17, left: 12, right: 12, bottom: 17.95),
                        decoration: const ShapeDecoration(
                          color: Color(0xFF292931),
                          shape: OvalBorder(),
                        ),
                        child: Image.asset(
                          "assets/send_icon.png",
                          width: 32,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Send',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
                // 입금
                Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.only(
                            top: 12, left: 12, right: 12.28, bottom: 12),
                        decoration: const ShapeDecoration(
                          color: Color(0xFF292931),
                          shape: OvalBorder(),
                        ),
                        child: Image.asset(
                          "assets/deposit_icon.png",
                          width: 32,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Deposit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
                // 교환
                Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(10),
                        decoration: const ShapeDecoration(
                          color: Color(0xFF292931),
                          shape: OvalBorder(),
                        ),
                        child: Image.asset(
                          "assets/exchange_icon.png",
                          width: 36,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Exchange',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
                // 활동 내역
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(
                            'https://testnet.bscscan.com/address/${walletAddress().toString()}'));
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.only(
                            top: 13, left: 16, right: 16, bottom: 12.37),
                        decoration: const ShapeDecoration(
                          color: Color(0xFF292931),
                          shape: OvalBorder(),
                        ),
                        child: Image.asset(
                          "assets/activity_icon.png",
                          width: 24,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'Activity',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          // 디바이더
          Container(
            margin: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 8,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFF1C1C26),
                ),
              ),
            ),
          ),
          // MTB 토큰
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 토큰 아이콘
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF262626),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Image.asset(
                        "assets/mtb_icon.png",
                        width: 21.31,
                        height: 20,
                      ),
                    ),
                    // 토큰 이름
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MTB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'MintB Token',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$mtbAmount MTB',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF3DDFCE),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '\$ ${mtbValue()}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 11,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 토큰 아이콘
                    Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: ShapeDecoration(
                        color: const Color(0xFF262626),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                      ),
                      child: Image.asset(
                        "assets/bnb_icon.png",
                        width: 30,
                      ),
                    ),
                    // 토큰 이름
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BNB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Binance Coin',
                          style: TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$bnbAmount BNB',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFFFBBC05),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          '\$ ${bnbValue()}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Color(0xFF8C8C8C),
                            fontSize: 11,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          // 토큰 목록
        ],
      ),
    );
  }
}
