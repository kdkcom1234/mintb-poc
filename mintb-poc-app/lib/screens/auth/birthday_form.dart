import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/back_nav_button.dart';

class BirthdayForm extends StatefulWidget {
  const BirthdayForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BirthdayFormState();
  }
}

class _BirthdayFormState extends State<BirthdayForm> {
  final TextEditingController yearController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final FocusNode monthFocus = FocusNode();
  final FocusNode dayFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // yearController.text = "1990";
    // monthController.text = "10";
    // dayController.text = "04";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  /* -- back navigation */
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: BackNavButton(context),
                      ),
                    ],
                  ),
                  /* -- text */
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Column(children: [
                        const Row(
                          children: [
                            Text(
                              '생년월일',
                              style: TextStyle(
                                  color: Color(0xFF3EDFCF),
                                  fontSize: 32,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0),
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 46),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: const Text(
                                    '다른 유저에게는 나이만 보이고, 생년월일은 공개되지 않습니다.',
                                    style: TextStyle(
                                      color: Color(0xFFD1D1D1),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ])),
                  /* -- form */
                  Padding(
                      padding: const EdgeInsets.only(left: 16, top: 40),
                      child: Row(children: [
                        /* -- year */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                '년',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF949494),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 48,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 24),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF343434),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  if (text.length == 4) {
                                    monthFocus.requestFocus();
                                  }
                                  if (text.length > 4) {
                                    yearController.text = text.substring(0, 4);
                                  }
                                },
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.only(top: 6, bottom: 13),
                                    border: InputBorder.none,
                                    hintText: "YYYY",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    )),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: yearController,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        /* -- month */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                '월',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF949494),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 48,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 24),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF343434),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  if (text.length == 2) {
                                    dayFocus.requestFocus();
                                  }
                                  if (text.length > 2) {
                                    monthController.text = text.substring(0, 2);
                                  }
                                },
                                focusNode: monthFocus,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.only(top: 6, bottom: 13),
                                    border: InputBorder.none,
                                    hintText: "MM",
                                    hintStyle: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    )),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: monthController,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        /* -- day */
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                '일',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF949494),
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 48,
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(top: 24),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF343434),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: TextField(
                                onChanged: (text) {
                                  if (text.length > 2) {
                                    dayController.text = text.substring(0, 2);
                                  }
                                },
                                focusNode: dayFocus,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.only(top: 6, bottom: 13),
                                  border: InputBorder.none,
                                  hintText: "DD",
                                  hintStyle: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: dayController,
                              ),
                            )
                          ],
                        ),
                      ])),
                  /* -- bottom button */
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 16, bottom: 16),
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                              backgroundColor: const Color(0xFF25ECD7),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed("/auth/gender-form");
                          },
                          child: const Text(
                            '다음',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF343434),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ]))));
  }
}
