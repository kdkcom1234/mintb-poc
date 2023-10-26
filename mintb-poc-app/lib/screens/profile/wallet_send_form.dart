import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mintb_poc_app/extensions.dart';
import 'package:mintb_poc_app/offchain/web3_integration.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

class WalletSendForm extends StatefulWidget {
  const WalletSendForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WalletSendFormState();
  }
}

class _WalletSendFormState extends State<WalletSendForm> {
  var fromAddress = walletAddress().toString();

  final TextEditingController toAddressController = TextEditingController();
  var toAddressValidateMessage = "";

  var balance = "0";

  final TextEditingController amountController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // toAddressController.text = "0x5f694aB1653A007d0025e4763e9096ffC9363F14";

    setBalanceValue();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setBalanceValue();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> setBalanceValue() async {
    final result = await getTokenBalance();
    // log(result.toString());

    setState(() {
      balance = double.parse(result)
          .truncateToDecimalPlaces(4)
          .toString()
          .formatNumberWithCommas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xFF1C1C26),
          child: SafeArea(
              child: Column(children: [
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFF343434),
              child: Column(
                children: [
                  Row(
                    children: [BackNavButton(context)],
                  ),
                  // 주소 섹션
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(top: 8, left: 20, right: 20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF262626),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 메인넷
                        Container(
                            height: 40,
                            decoration: const ShapeDecoration(
                              color: Color(0xFF1C1C26),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(width: 1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(4),
                                ),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 10, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Mainnet',
                                    style: TextStyle(
                                      color: Color(0xFFD1D1D1),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  Text(
                                    'BSC Network',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFFFBBC05),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        // From 주소
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16, left: 10, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'From',
                                style: TextStyle(
                                  color: Color(0xFFD1D1D1),
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'My wallet ',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Color(0xFF3EDFCF),
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    fromAddress.shortenFromAddress(),
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF8C8C8C),
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
                        // 다바이더
                        Container(
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF1C1C26),
                              ),
                            ),
                          ),
                        ),
                        // To 주소
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 13),
                                child: Text(
                                  'To',
                                  style: TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 240,
                                    height: 40,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFF373737),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 0.50),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextField(
                                        onChanged: (text) {
                                          if (!isValidEthereumAddress(text)) {
                                            setState(() {
                                              toAddressValidateMessage =
                                                  "invalid address";
                                            });
                                          } else {
                                            setState(() {
                                              toAddressValidateMessage = "";
                                            });
                                          }
                                        },
                                        controller: toAddressController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        decoration: const InputDecoration(
                                          hintText: 'Address',
                                          hintStyle: TextStyle(
                                            color: Color(0xFF8C8C8C),
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              top: 10, right: 12, bottom: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    toAddressValidateMessage,
                                    style: const TextStyle(
                                      color: Color(0xFFDE5854),
                                      fontSize: 10,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w300,
                                      height: 0,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // 수량 섹션
                  Container(
                    height: 180,
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF262626),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 토큰 선택
                        Container(
                          padding: const EdgeInsets.only(
                              top: 25, bottom: 7, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  'Token',
                                  style: TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                width: 240,
                                height: 40,
                                padding: const EdgeInsets.only(right: 6),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF1C1C26),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 1, color: Color(0xFF3DDFCE)),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/mtb_icon.png",
                                        ),
                                        const Text(
                                          'MTB',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        )
                                      ],
                                    ),
                                    Image.asset(
                                      "assets/dropdown_button_primary.png",
                                      height: 26,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // 밸런스
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Balance : ',
                                        style: TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontSize: 10,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          // height: 0,
                                        ),
                                      ),
                                      TextSpan(
                                        text: balance,
                                        style: const TextStyle(
                                          color: Color(0xFF3DDFCE),
                                          fontSize: 10,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          // height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.right,
                                )
                              ],
                            )),
                        // 디바이더
                        Container(
                          margin: const EdgeInsets.only(top: 7, bottom: 25),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFF1C1C26),
                              ),
                            ),
                          ),
                        ),
                        // 수량 입력
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  'Amount',
                                  style: TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Container(
                                width: 240,
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF373737),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 0.50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 7,
                                      top: 8,
                                      child: Container(
                                          width: 56,
                                          height: 25,
                                          decoration: ShapeDecoration(
                                            color: const Color(0xFF3DDFCE),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                amountController.text =
                                                    balance.replaceAll(",", "");
                                                log("max");
                                              });
                                            },
                                            child: const Center(
                                              child: Text(
                                                'MAX',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Color(0xFF343434),
                                                  fontSize: 10,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700,
                                                  height: 1,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Positioned(
                                        left: 72,
                                        top: 0,
                                        child: SizedBox(
                                          width: 168,
                                          height: 40,
                                          child: TextField(
                                            controller: amountController,
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                                decimal: true), // 숫자 및 소수점만 허용
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign:
                                                TextAlign.right, // 텍스트를 우측 정렬
                                            textAlignVertical: TextAlignVertical
                                                .center, // 세로로는 가운데 정렬
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintText: '0', // 힌트 텍스트 추가
                                              hintStyle: TextStyle(
                                                // 힌트 텍스트 스타일
                                                color: Color(0xFF8C8C8C),
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                              ),
                                              contentPadding: EdgeInsets.only(
                                                  // left: 70,
                                                  top: 10,
                                                  right: 12,
                                                  bottom: 12),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (toAddressController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please enter the `to address`.",
                                      toastLength: Toast.LENGTH_LONG);

                                  return;
                                }

                                if (toAddressValidateMessage.isNotEmpty) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please enter the valid `to address`.",
                                      toastLength: Toast.LENGTH_LONG);

                                  return;
                                }

                                if (amountController.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please enter the amount of tokens.",
                                      toastLength: Toast.LENGTH_LONG);

                                  return;
                                }

                                if (amountController.text.toDouble() >
                                    balance.toDouble()) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please enter the valid amount of tokens.",
                                      toastLength: Toast.LENGTH_LONG);

                                  return;
                                }

                                Navigator.of(context).pushNamed(
                                    "/profile/wallet/send-review",
                                    arguments: {
                                      "from": fromAddress,
                                      "to": toAddressController.text,
                                      "amount":
                                          amountController.text.removeCommas(),
                                      "token": "MTB"
                                    });

                                FocusScope.of(context).unfocus();
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.zero), // 기본 패딩 제거
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF25ECD7)), // 배경색 설정
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(8), // 모서리 라운드 처리
                                  ),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 32,
                                height: 50,
                                alignment: Alignment.center,
                                child: const Text(
                                  'Next',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF343434),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ))
          ]))),
    );
  }
}
