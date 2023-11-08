import 'package:flutter/material.dart';
import 'package:mintb_poc_app/env.dart';

import '../../widgets/back_nav_button.dart';

class LanguagePriorityForm extends StatefulWidget {
  const LanguagePriorityForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LanguagePriorityFormState();
  }
}

class _LanguagePriorityFormState extends State<LanguagePriorityForm> {
  List<int> languagesRange = [];
  var selectedLanguages = [];

  @override
  Widget build(BuildContext context) {
    if (languagesRange.isEmpty) {
      languagesRange = ModalRoute.of(context)!.settings.arguments as List<int>;
      selectedLanguages.add(languagesRange[0]);
    }

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
                              '선호하는 언어',
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
                                    '선호하시는 언어가 프로필에 먼저 표시되고, 회원님과 같은 언어를 선호하는 사람들과 연결될 수 있도록 도와드릴께요.',
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
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Column(
                        children: languagesRange
                            .map((e) => Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  margin: languagesRange.indexOf(e) == 0
                                      ? const EdgeInsets.only(bottom: 16)
                                      : EdgeInsets.zero,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF282831),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: selectedLanguages.contains(e)
                                              ? const Color(0xFF3DDFCE)
                                              : Colors.transparent),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x3F000000),
                                        blurRadius: 2,
                                        offset: Offset(2, 2),
                                        spreadRadius: 0,
                                      )
                                    ],
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (selectedLanguages.contains(e) &&
                                              selectedLanguages.length > 1) {
                                            selectedLanguages.remove(e);
                                          } else {
                                            selectedLanguages.add(e);
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              languages[e],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: selectedLanguages
                                                        .contains(e)
                                                    ? const Color(0xFF3DDFCE)
                                                    : const Color(0xFFE5E5E5),
                                                fontSize: 16,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            Image(
                                              image: selectedLanguages
                                                      .contains(e)
                                                  ? const AssetImage(
                                                      "assets/check_active.png")
                                                  : const AssetImage(
                                                      "assets/check_inactive.png"),
                                              width: 20,
                                            )
                                          ],
                                        ),
                                      )),
                                ))
                            .toList(),
                      )),
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
                                          '여러 언어를 선택할 수 있습니다',
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
                                            .pushNamed("/auth/policy-confirm");
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
