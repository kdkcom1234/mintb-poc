import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/profile_collection.dart';
import 'package:mintb_poc_app/firebase/storage/files.dart';
import 'package:mintb_poc_app/screens/home.dart';

import '../../preferences/profile_local.dart';
import '../../widgets/back_nav_button.dart';

class PolicyConfirm extends StatefulWidget {
  const PolicyConfirm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PolicyConfirmState();
  }
}

class _PolicyConfirmState extends State<PolicyConfirm> {
  var loading = false;

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
                              '이제 마지막 단계입니다!',
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
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: const Text(
                                    '서비스를 이용하기 위해서, 이용약관에 동의해주세요.',
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
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: const Text(
                                    '이용약관 자세히 보기',
                                    style: TextStyle(
                                      color: Color(0xFFFBBC05),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFFFBBC05),
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: const Text(
                                    '저희는 안전하고 포용적이면서 사랑이 넘치는 데이팅 환경을 만들고자 노력하고 있습니다.\n저희가 이런 환경을 만들어 나갈 수 있도록\n운영방침을 준수해주세요.',
                                    style: TextStyle(
                                      color: Color(0xFFD1D1D1),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: const Text(
                                    '운영방침 자세히 보기',
                                    style: TextStyle(
                                      color: Color(0xFFFBBC05),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFFFBBC05),
                                      height: 0,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ])),
                  /* -- bottom button */
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 16, right: 16),
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
                                log(profileLocal.toJson().toString());

                                setState(() {
                                  loading = true;
                                });

                                // 이미지 업로드
                                List<String> imageUrlList = [];
                                for (final path in profileLocal.images) {
                                  final url = await uploadFile(File(path));
                                  imageUrlList.add(url);
                                }
                                final toSaveProfileLocal = ProfileLocal(
                                    nickname: profileLocal.nickname,
                                    age: profileLocal.age,
                                    gender: profileLocal.gender,
                                    images: imageUrlList,
                                    languages: profileLocal.languages);

                                // preference 저장
                                await saveProfileLocal(toSaveProfileLocal);
                                // firestore 저장
                                await createProfile(toSaveProfileLocal);

                                setState(() {
                                  loading = false;
                                });

                                if (!mounted) return;
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const Home()),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            })();
                          },
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF343434),
                                  ))
                              : const Text(
                                  '모두 동의하고 회원가입 완료',
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
