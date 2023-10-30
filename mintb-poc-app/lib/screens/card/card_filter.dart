import 'dart:developer';

import 'package:flutter/material.dart';

import '../../preferences/filter_local.dart';
import '../../widgets/range_slider_custome_shape.dart';
import '../../widgets/slider_custom_shape.dart';

class CardFilter extends StatefulWidget {
  const CardFilter({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardFilterState();
  }
}

class _CardFilterState extends State<CardFilter> {
  static const double ageSliderMin = 18.0;
  static const double ageSliderMax = 80.0;
  static const double distanceSliderMin = 2;
  static const double distanceSliderMax = 160.0;

  RangeValues ageRange = const RangeValues(18, 80);
  double distanceMax = 2;

  void loadFilter() async {
    final filter = await getFilterLocal();
    if (filter != null) {
      log("--load--");
      setState(() {
        ageRange =
            RangeValues(filter.ageMin.toDouble(), filter.ageMax.toDouble());
        distanceMax = filter.distanceMax.toDouble();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF1C1C26),
            child: SafeArea(
                child: Column(
              children: [
                Container(
                  height: 48,
                  decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 48,
                          height: 48,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Image.asset(
                                "assets/close_button.png",
                                width: 38,
                                height: 38,
                              ),
                            ),
                          )),
                      const Text(
                        '필터 선택하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFE5E5E5),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w800,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                        height: 48,
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                        color: const Color(0xFF343434),
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '나이',
                                  style: TextStyle(
                                    color: Color(0xFFB2BABB),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '${ageRange?.start.toInt()} ~ ${ageRange?.end.toInt()}세',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF3DDFCE),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            /* -- 나이 슬라이더 -- */
                            SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 8.0,
                                  inactiveTrackColor: const Color(0xFF1C1C26),
                                  activeTrackColor:
                                      const Color(0xFF1C1C26), // 원하는 색상으로 변경
                                  rangeThumbShape:
                                      CustomRangeSliderThumbShape(), // 커스텀 thumb shape
                                  rangeTrackShape:
                                      CustomRangeSliderTrackShape(),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: RangeSlider(
                                    values: ageRange,
                                    min: ageSliderMin,
                                    max: ageSliderMax,
                                    divisions: ageSliderMax.toInt() -
                                        ageSliderMin.toInt(),
                                    onChanged: (val) async {
                                      setState(() {
                                        ageRange = val;
                                      });

                                      var filter = await getFilterLocal();
                                      if (filter == null) {
                                        filter = FilterLocal(
                                            ageMin: val.start.toInt(),
                                            ageMax: val.end.toInt(),
                                            distanceMax: distanceMax.toInt());
                                      } else {
                                        filter.ageMin = val.start.toInt();
                                        filter.ageMax = val.end.toInt();
                                      }

                                      saveFilterLocal(filter);
                                    })),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '거리',
                                  style: TextStyle(
                                    color: Color(0xFFB2BABB),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '~ ${distanceMax.toInt()}km',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF3DDFCE),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            /* -- 거리 슬라이더 -- */
                            SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 8.0,
                                  inactiveTrackColor: const Color(0xFF1C1C26),
                                  activeTrackColor:
                                      const Color(0xFF1C1C26), // 원하는 색상으로 변경
                                  thumbShape:
                                      CustomSliderThumbShape(), // 커스텀 thumb shape
                                  trackShape: CustomSliderTrackShape(),
                                  overlayShape: SliderComponentShape.noOverlay,
                                ),
                                child: Slider(
                                    value: distanceMax,
                                    min: distanceSliderMin,
                                    max: distanceSliderMax,
                                    divisions: distanceSliderMax.toInt() -
                                        distanceSliderMin.toInt(),
                                    onChanged: (val) async {
                                      setState(() {
                                        distanceMax = val;
                                      });

                                      var filter = await getFilterLocal();
                                      if (filter == null) {
                                        filter = FilterLocal(
                                            ageMin: ageRange.start.toInt(),
                                            ageMax: ageRange.end.toInt(),
                                            distanceMax: val.toInt());
                                      } else {
                                        filter.distanceMax = val.toInt();
                                      }

                                      saveFilterLocal(filter);
                                    })),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              '다른 회원의 구사 언어',
                              style: TextStyle(
                                color: Color(0xFFB2BABB),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF282831),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '언어를 선택하세요',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF3DDFCE),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/right_arrow_primary.png",
                                    width: 10,
                                    height: 15.5,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            const Text(
                              '고급 필터',
                              style: TextStyle(
                                color: Color(0xFFB2BABB),
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF282831),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    '고급 필터 설정',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF3DDFCE),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/right_arrow_primary.png",
                                    width: 10,
                                    height: 15.5,
                                  )
                                ],
                              ),
                            )
                          ],
                        )))
              ],
            ))));
  }
}
