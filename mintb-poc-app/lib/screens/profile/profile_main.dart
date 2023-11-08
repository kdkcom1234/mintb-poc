import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mintb_poc_app/env.dart';
import 'package:mintb_poc_app/firebase/auth.dart';
import 'package:mintb_poc_app/screens/auth/sign_in.dart';
import 'package:mintb_poc_app/screens/profile/profile_info.dart';
import 'package:mintb_poc_app/screens/profile/wallet_info.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileMainState();
  }
}

class _ProfileMainState extends State<ProfileMain> {
  final tabs = ["profile", "wallet"];
  var selectedTab = 0;
  var isPurchasePending = false;

  var isPurchaseMint = false;
  void handleOpenPurchaseMint() {
    setState(() {
      isPurchaseMint = true;
    });
  }

  void handleClosePurchaseMint() {
    log("--close");
    setState(() {
      isPurchaseMint = false;
    });
  }

  void handlePurchaseMint(int amount) async {
    String? idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
    log(idToken!);

    try {
      setState(() {
        isPurchasePending = true;
      });
      // HTTP 요청을 보냅니다.
      final response = await http.post(
          // 클라우드 함수의 URL을 지정합니다.
          Uri.parse('${apiBase()}/points/mint/purchase'),
          // HTTP 헤더를 구성합니다. 인증 토큰을 포함해야 합니다.
          headers: {
            'Authorization': 'Bearer $idToken',
          },
          body: {
            "amount": amount.toString()
          });
      // 결과를 처리합니다.
      if (response.statusCode == 200) {
        // 성공적으로 함수를 호출하고 응답을 받았습니다.
        log('Function called successfully: ${response.body}');
      } else {
        // 서버 오류 또는 요청 오류가 발생했습니다.
        log('Function call failed: ${response.body}');
        Fluttertoast.showToast(msg: 'Function call failed: ${response.body}');
      }
    } catch (e) {
      // 네트워크 오류 또는 요청 예외가 발생했습니다.
      log('Error calling function: $e');
      Fluttertoast.showToast(msg: 'Error calling function: $e');
    } finally {
      setState(() {
        isPurchasePending = false;
        isPurchaseMint = false;
      });
    }
  }

  Widget displayMintItem(int amount, double value) {
    final imgPos = {
      "1": {"marginTop": 29.0, "width": 40.0, "height": 40.0},
      "10": {"marginTop": 21.0, "width": 64.0, "height": 54.0},
      "50": {"marginTop": 13.0, "width": 70.0, "height": 67.0},
      "100": {"marginTop": 2.0, "width": 126.0, "height": 99.0},
    };

    final marginTop = imgPos[amount.toString()]!["marginTop"]!;
    final width = imgPos[amount.toString()]!["width"]!;
    final height = imgPos[amount.toString()]!["height"]!;

    return Expanded(
        child: Container(
      height: 180,
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFF343434),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Text(
            '$amount mint ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF3EDFCF),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          SizedBox(
            height: marginTop,
          ),
          Image.asset(
            "assets/mint_${amount}_icon.png",
            width: width,
            height: height,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  handlePurchaseMint(amount);
                },
                child: Container(
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFB74D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Center(
                      child: Text(
                        '\$$value',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF343434),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    )),
              )
            ],
          ))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xFF1C1C26),
          child: SafeArea(
              child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: const Color(0xFF343434),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                /* -- 탭 버튼 */
                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(
                                          width: 40,
                                          height: 40,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedTab = 0;
                                                });
                                              },
                                              child: Container(
                                                width: 88,
                                                height: 40,
                                                decoration: ShapeDecoration(
                                                  color: selectedTab == 0
                                                      ? const Color(0xFF3DDFCE)
                                                      : const Color(0xFF343434),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF3EDFCF)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(8),
                                                      bottomLeft:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Profile',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: selectedTab == 0
                                                        ? const Color(
                                                            0xFF343434)
                                                        : const Color(
                                                            0xFF949494),
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedTab = 1;
                                                });
                                              },
                                              child: Container(
                                                width: 88,
                                                height: 40,
                                                decoration: ShapeDecoration(
                                                  color: selectedTab == 1
                                                      ? const Color(0xFF3DDFCE)
                                                      : const Color(0xFF343434),
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color:
                                                            Color(0xFF3EDFCF)),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(8),
                                                      bottomRight:
                                                          Radius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Wallet',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: selectedTab == 1
                                                        ? const Color(
                                                            0xFF343434)
                                                        : const Color(
                                                            0xFF949494),
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w400,
                                                    height: 0,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Image.asset(
                                            "assets/setting_icon.png",
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ]),
                                ),
                                selectedTab == 0
                                    ? ProfileInfo(
                                        onPurchaseMint: handleOpenPurchaseMint,
                                      )
                                    : const WalletInfo(),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        await signOut();
                                        if (context.mounted) {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const SignIn()),
                                            (Route<dynamic> route) => false,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF1C1C26), // Button background color
                                        fixedSize:
                                            const Size(328, 50), // Button size
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              8), // Button corner radius
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: const Text(
                                        '로그아웃',
                                        style: TextStyle(
                                          color: Color(0xFF3EDFCF),
                                          fontSize: 16,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    )
                                  ],
                                ))
                              ],
                            ),
                          )))
                ],
              ),
              // 민트 구매 박스
              isPurchaseMint
                  ? Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: const Color.fromRGBO(28, 28, 38, 0.50),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 500,
                                child: GestureDetector(
                                    onTap: handleClosePurchaseMint),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 500,
                                padding: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF1C1C26),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                child: !isPurchasePending
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              displayMintItem(1, 0.99),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              displayMintItem(10, 9.99)
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              displayMintItem(50, 49.99),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              displayMintItem(100, 99.99),
                                            ],
                                          )
                                        ],
                                      )
                                    : const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                            ],
                          )))
                  : const SizedBox.shrink()
            ],
          ))),
    );
  }
}
