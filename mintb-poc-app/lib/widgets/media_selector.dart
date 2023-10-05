import 'package:flutter/material.dart';

class MediaSelector extends StatefulWidget {
  const MediaSelector({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MediaSelectorState();
  }
}

class _MediaSelectorState extends State<MediaSelector> {
  // 0xFF343434

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(
              children: [
                /* -- top menu bar */
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 48,
                  color: const Color(0xFF1C1C26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 68,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Image(
                                  image: AssetImage("assets/close_button.png"),
                                  width: 38,
                                  height: 38,
                                ),
                              ),
                            ],
                          )),
                      const Text(
                        '사진 선택하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                      SizedBox(
                          width: 68,
                          child: Stack(
                            children: [
                              Positioned(
                                  right: 8,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(60, 32),
                                        backgroundColor:
                                            const Color(0xFF25ECD7),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    child: const Text(
                                      '저장하기',
                                      style: TextStyle(
                                        color: Color(0xFF343434),
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w800,
                                        height: 0,
                                      ),
                                    ),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
                /* -- folder, length */
                Container(
                  color: const Color(0xFF343434),
                  padding: const EdgeInsets.only(
                      left: 8, top: 8, bottom: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(60, 32),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: const BorderSide(
                                  width: 1, color: Color(0xFF3DDFCE))),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '최근 ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3EDFCF),
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w800,
                                  height: 0,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image(
                                image:
                                    AssetImage("assets/down_caret_primary.png"),
                                width: 10,
                              )
                            ],
                          )),
                      const Text(
                        '5 / 5 선택됨',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3DDFCE),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
                /* -- image list */
                Expanded(
                    child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF343434),
                  child: Wrap(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 2) / 3,
                        height: (MediaQuery.of(context).size.width - 2) / 3,
                        child: InkWell(
                          onTap: () {},
                          child: const Image(
                            image: AssetImage("assets/profile_sample.png"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 2) / 3,
                        height: (MediaQuery.of(context).size.width - 2) / 3,
                        child: InkWell(
                          onTap: () {},
                          child: const Image(
                            image: AssetImage("assets/profile_sample.png"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 2) / 3,
                        height: (MediaQuery.of(context).size.width - 2) / 3,
                        child: InkWell(
                          onTap: () {},
                          child: const Image(
                            image: AssetImage("assets/profile_sample.png"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 2) / 3,
                        height: (MediaQuery.of(context).size.width - 2) / 3,
                        child: InkWell(
                          onTap: () {},
                          child: const Image(
                            image: AssetImage("assets/profile_sample.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ))));
  }
}
