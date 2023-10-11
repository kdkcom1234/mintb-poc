import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

class WalletSendForm extends StatefulWidget {
  const WalletSendForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WalletSendFormState();
  }
}

class _WalletSendFormState extends State<WalletSendForm> {
  var fromAddress = "0x34...a5253";
  final TextEditingController toAddressController = TextEditingController();
  var toAddressMessage = "Validation message";

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
                                    fromAddress,
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
                                        controller: toAddressController,
                                        style: const TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
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
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    toAddressMessage,
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
          ]))),
    );
  }
}
