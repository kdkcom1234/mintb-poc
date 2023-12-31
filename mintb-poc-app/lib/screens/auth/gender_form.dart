import 'package:flutter/material.dart';

import '../../preferences/profile_local.dart';
import '../../widgets/back_nav_button.dart';

class GenderForm extends StatefulWidget {
  const GenderForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GenderFormState();
  }
}

class _GenderFormState extends State<GenderForm> {
  final genders = ["여성", "남성"];
  var selectedGender = 0;

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
                              '성별',
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
                                    '회원님의 성별을 알려주세요.',
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
                        children: genders
                            .map((e) => Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  margin: genders.indexOf(e) == 0
                                      ? const EdgeInsets.only(bottom: 16)
                                      : EdgeInsets.zero,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF282831),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color: selectedGender ==
                                                  genders.indexOf(e)
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
                                          selectedGender = genders.indexOf(e);
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
                                              e,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: selectedGender ==
                                                        genders.indexOf(e)
                                                    ? const Color(0xFF3DDFCE)
                                                    : const Color(0xFFE5E5E5),
                                                fontSize: 16,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                                height: 0,
                                              ),
                                            ),
                                            Image(
                                              image: selectedGender ==
                                                      genders.indexOf(e)
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
                            (() async {
                              final profileLocal = await getProfileLocal();

                              if (profileLocal != null) {
                                await saveProfileLocal(ProfileLocal(
                                    nickname: profileLocal.nickname,
                                    age: profileLocal.age,
                                    gender: selectedGender,
                                    images: [],
                                    languages: []));

                                if (!mounted) return;
                                Navigator.of(context).pushNamed(
                                    "/auth/profile-image-registration");
                              }
                            })();
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
