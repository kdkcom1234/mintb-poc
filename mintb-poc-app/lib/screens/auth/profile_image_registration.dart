import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mintb_poc_app/widgets/profile_image_tile.dart';

import '../../preferences/profile_local.dart';
import '../../widgets/back_nav_button.dart';
import '../../widgets/media_selector.dart';

class ProfileImageRegistration extends StatefulWidget {
  const ProfileImageRegistration({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileImageRegistrationState();
  }
}

class _ProfileImageRegistrationState extends State<ProfileImageRegistration> {
  final List<File?> selectedImages = [];
  final maxSelectSize = 6;

  void removeImage(int index) {
    final dialogWidth = MediaQuery.of(context).size.width;
    final dialogHeight = MediaQuery.of(context).size.height;

    log(dialogWidth.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          elevation: 0, // 기본 그림자 제거
          backgroundColor: Colors.transparent, // 백그라운드 색상 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: SizedBox(
            width: dialogWidth, // 원하는 너비
            height: dialogHeight, // 원하는 높이
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedImages.removeAt(index);
                    });
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF292931)),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    elevation: MaterialStateProperty.all(0), // 그림자 제거
                  ),
                  child: SizedBox(
                    width: dialogWidth,
                    height: 60,
                    child: const Center(
                      child: Text(
                        '삭제',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFDE5854),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Handle the button press
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF343434)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  child: SizedBox(
                    width: dialogWidth,
                    height: 60,
                    child: const Center(
                      child: Text(
                        '취소',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFE5E5E5),
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> loadImages() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MediaSelector(
        maxSelectSize: maxSelectSize - selectedImages.length,
      ),
      fullscreenDialog: true,
    )) as List<File?>?;

    if (result != null) {
      log(result.toString());
      setState(() {
        for (final file in result) {
          selectedImages.add(file);
        }
      });
    }
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ProfileImageTile(
                                  isPrimary: true,
                                  file: selectedImages.isNotEmpty
                                      ? selectedImages[0]
                                      : null,
                                  onTap: selectedImages.isNotEmpty
                                      ? () {
                                          removeImage(0);
                                        }
                                      : () {
                                          loadImages();
                                        },
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  children: [
                                    ProfileImageTile(
                                        file: selectedImages.length > 1
                                            ? selectedImages[1]
                                            : null,
                                        onTap: selectedImages.length > 1
                                            ? () {
                                                removeImage(1);
                                              }
                                            : () {
                                                loadImages();
                                              }),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    ProfileImageTile(
                                        file: selectedImages.length > 2
                                            ? selectedImages[2]
                                            : null,
                                        onTap: selectedImages.length > 2
                                            ? () {
                                                removeImage(2);
                                              }
                                            : () {
                                                loadImages();
                                              }),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                ProfileImageTile(
                                    file: selectedImages.length > 3
                                        ? selectedImages[3]
                                        : null,
                                    onTap: selectedImages.length > 3
                                        ? () {
                                            removeImage(3);
                                          }
                                        : () {
                                            loadImages();
                                          }),
                                const SizedBox(
                                  width: 16,
                                ),
                                ProfileImageTile(
                                    file: selectedImages.length > 4
                                        ? selectedImages[4]
                                        : null,
                                    onTap: selectedImages.length > 2
                                        ? () {
                                            removeImage(4);
                                          }
                                        : () {
                                            loadImages();
                                          }),
                                const SizedBox(
                                  width: 16,
                                ),
                                ProfileImageTile(
                                    file: selectedImages.length > 5
                                        ? selectedImages[5]
                                        : null,
                                    onTap: selectedImages.length > 5
                                        ? () {
                                            removeImage(5);
                                          }
                                        : () {
                                            loadImages();
                                          }),
                              ],
                            )
                          ],
                        ),
                      ),
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
                                      onPressed: () {
                                        if (selectedImages.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please select one or more images");
                                          return;
                                        }
                                        (() async {
                                          // save local profile
                                          final profileLocal =
                                              await getProfileLocal();

                                          if (profileLocal != null) {
                                            await saveProfileLocal(ProfileLocal(
                                                nickname: profileLocal.nickname,
                                                age: profileLocal.age,
                                                gender: profileLocal.gender,
                                                images: selectedImages
                                                    .map((e) => e!.path)
                                                    .toList()));

                                            log((await getProfileLocal())!
                                                .toJson()
                                                .toString());

                                            if (!mounted) return;
                                            Navigator.of(context).pushNamed(
                                                "/auth/language-form");
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
                              )
                            ],
                          )))
                ]))));
  }
}
