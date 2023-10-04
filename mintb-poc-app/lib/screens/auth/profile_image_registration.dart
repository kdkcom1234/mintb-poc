import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/profile_image_tile.dart';

import '../../widgets/back_nav_button.dart';

class ProfileImageRegistration extends StatefulWidget {
  const ProfileImageRegistration({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileImageRegistrationState();
  }
}

class _ProfileImageRegistrationState extends State<ProfileImageRegistration> {
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
                              '프로필 이미지',
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
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: const Text(
                                '회원님 마음대로 골라주세요! 반려동물과 함꼐 찍은 사진이나, 좋아하는 음식을 먹는 사진 혹은 좋아하는 장소에서 찍은 사진 뭐든 좋습니다.',
                                style: TextStyle(
                                  color: Color(0xFFD1D1D1),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                      ])),
                  /* image tile */
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: InkWell(
                            onTap: () {},
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    ProfileImageTile(
                                      isPrimary: true,
                                    ),
                                    SizedBox(width: 16),
                                    Column(
                                      children: [
                                        ProfileImageTile(),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        ProfileImageTile(),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    ProfileImageTile(),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    ProfileImageTile(),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    ProfileImageTile(),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),

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
                                        image:
                                            AssetImage("assets/help_icon.png"),
                                        width: 18,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Text(
                                          '어느 사진을 고를지 망설여지나요?',
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
                                      onPressed: () {},
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
