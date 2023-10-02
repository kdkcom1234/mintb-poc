import 'package:flutter/material.dart';

import '../../widgets/back_nav_button.dart';

class PhoneCountry extends StatefulWidget {
  const PhoneCountry({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PhoneCountryState();
  }
}

class _PhoneCountryState extends State<PhoneCountry> {
  final countryNames = ["미국", "영국", "한국"];
  final countryCodes = ["+1", "+44", "+82"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
            child: SafeArea(
                child: Column(children: [
              /* -- back navigation */
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: BackNavButton(context),
                  )
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: ListView.builder(
                    itemCount: countryNames.length,
                    itemBuilder: (ctx, idx) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop({
                            "countryName": countryNames[idx],
                            "countryCode": countryCodes[idx],
                          });
                        },
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF282831),
                            borderRadius: BorderRadius.circular(8),
                            border: Border(
                              top: idx == 0
                                  ? const BorderSide(width: 1)
                                  : const BorderSide(width: 0), // 상단 테두리
                              left: const BorderSide(width: 1), // 좌측 테두리
                              right: const BorderSide(width: 1), // 우측 테두리
                              bottom: const BorderSide(width: 1), // 하단 테두리를 제거
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(2, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                countryNames[idx],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                              Text(
                                countryCodes[idx],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFE5E5E5),
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ))
            ]))));
  }
}
