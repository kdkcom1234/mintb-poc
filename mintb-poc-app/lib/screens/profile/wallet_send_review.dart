import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mintb_poc_app/extensions.dart';

import '../../offchain/web3_integration.dart';
import '../../widgets/back_nav_button.dart';

class WalletSendReview extends StatefulWidget {
  const WalletSendReview({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WalletSendReviewState();
  }
}

class _WalletSendReviewState extends State<WalletSendReview> {
  var gasFee = "0.00012 BNB";
  var fromAddress = "";
  var toAddress = "";
  var amount = "";
  var token = "";

  Future<void> setEstimatedGas() async {
    final result = await getEstimatedGas(toAddress, amount);
    log(result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (fromAddress.isEmpty) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      fromAddress = args["from"]!;
      toAddress = args["to"]!;
      amount = args["amount"]!;
      token = args["token"]!;

      setEstimatedGas();
    }

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
                  // from-to 섹션
                  Container(
                    height: 156,
                    margin: const EdgeInsets.only(
                        top: 14, right: 20, left: 20, bottom: 20),
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, right: 12),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF262626),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Column(
                      children: [
                        // 네트워크
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Mainnet',
                              style: TextStyle(
                                  color: Color(0xFFD1D1D1),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 0),
                            ),
                            Text(
                              'BSC Network',
                              textAlign: TextAlign.center,
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
                        const SizedBox(
                          height: 24,
                        ),
                        // From address
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'From',
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'My wallet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF3DDFCE),
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  fromAddress.shortenFromAddress(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
                        const SizedBox(
                          height: 28,
                        ),
                        // To address
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'To',
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Text(
                              toAddress.shortenFromAddress(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFCFCFC),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  // 수량 섹션
                  Container(
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    padding:
                        const EdgeInsets.only(top: 12, left: 12, right: 12),
                    height: 76,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF262626),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Amount',
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Text(
                              '$amount $token',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF3DDFCE),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Est. Gas fee',
                              style: TextStyle(
                                color: Color(0xFFD1D1D1),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            Text(
                              gasFee,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFBBC05),
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF1C1C26)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            elevation: MaterialStateProperty.all(0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              'Reject',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFE5E5E5),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                          flex: 1,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFF25ECD7)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              elevation: MaterialStateProperty.all(0),
                            ),
                            onPressed: () {
                              //TODO: 버튼을 눌렀을 때의 로직을 여기에 추가하세요
                              transferTokens(toAddress, amount);
                              var count = 0;
                              Navigator.popUntil(context, (route) {
                                return count++ == 2;
                              });
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'Confirm',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF343434),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ))
          ]))),
    );
  }
}
