import 'package:flutter/material.dart';

import '../../widgets/back_nav_button.dart';

class NicknameForm extends StatefulWidget {
  const NicknameForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NicknameFormState();
  }
}

class _NicknameFormState extends State<NicknameForm> {
  final TextEditingController nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nicknameController.text = "닉네임";
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
                  /* -- text, form */
                  Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Column(children: [
                        const Row(
                          children: [
                            Text(
                              '닉네임 입력',
                              style: TextStyle(
                                  color: Color(0xFF3EDFCF),
                                  fontSize: 32,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Row(
                              children: [
                                Text(
                                  '입력한 닉네임은 프로필에 표시됩니다.',
                                  style: TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          height: 48,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF343434),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: TextField(
                            style: const TextStyle(
                              color: Color(0xFFE5E5E5),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                            decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 16, top: 32, bottom: 13),
                                border: InputBorder.none,
                                hintText: "닉네임",
                                hintStyle: TextStyle(
                                  color: Color(0xFF888888),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                )),
                            controller: nicknameController,
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Text(
                                  '닉네임을 랜덤으로 생성할까요?',
                                  style: TextStyle(
                                    color: Color(0xFF949494),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF949494),
                                    height: 0,
                                  ),
                                ))
                          ],
                        ),
                      ])),
                  /* -- bottom text, button */
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            "assets/notice_icon.png"),
                                        width: 18,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          '닉네임은 나중에 변경할 수 없어요.',
                                          style: TextStyle(
                                            color: Color(0xFFD1D1D1),
                                            fontSize: 12,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        right: 16, bottom: 16),
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(50),
                                          backgroundColor:
                                              const Color(0xFF25ECD7),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12))),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("/auth/birthday-form");
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
                              )
                            ],
                          )))
                ]))));
  }
}
