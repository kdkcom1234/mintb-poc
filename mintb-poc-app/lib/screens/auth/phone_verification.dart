import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mintb_poc_app/widgets/back_nav_button.dart';

class PhoneVerification extends StatefulWidget {
  const PhoneVerification({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PhoneVerificationState();
  }
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final TextEditingController phoneTextController = TextEditingController();

  var countryName = "한국";
  var countryCode = "+82";

  @override
  Widget build(BuildContext context) {
    phoneTextController.text = "1033559944";

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
          child: SafeArea(
              child: Column(
            children: [
              /* -- back navigation */
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5),
                    child: BackNavButton(context),
                  )
                ],
              ),
              /* -- text contents */
              const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          '휴대폰 번호인증',
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
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        '안전하고 믿을 수 있는 커뮤니티를 운영하기 위해 모든 프로필이 실제 프로필인지 확인합니다.',
                        style: TextStyle(
                          color: Color(0xFFD1D1D1),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              /* -- forms -- */
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 40),
                child: Row(
                  children: [
                    /* -- country picker */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            '국가',
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
                          width: 120,
                          height: 48,
                          alignment: Alignment.topLeft,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF343434),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.only(
                                  top: 14, left: 16, bottom: 14),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "$countryName $countryCode",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFD1D1D1),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                const Image(
                                  image: AssetImage("assets/down_caret.png"),
                                  width: 11.5,
                                )
                              ],
                            ),
                            onPressed: () async {
                              final result = await Navigator.of(context)
                                      .pushNamed("/auth/phone-country")
                                  as Map<String, String>;

                              setState(() {
                                countryName = result["countryName"]!;
                                countryCode = result["countryCode"]!;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    /* -- phone number -- */
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            '전화번호',
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
                          width: 192,
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
                                  EdgeInsets.only(left: 15, top: 6, bottom: 16),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: phoneTextController,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              /* -- notice message */
              const Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 16, bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image(
                      image: AssetImage("assets/notice_icon.png"),
                      width: 18,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '휴대폰 번호는 공유되거나 프로필에 표시되지 않습니다.',
                      style: TextStyle(
                        color: Color(0xFFD1D1D1),
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              )),
              /* -- bottom button */
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: const Color(0xFF25ECD7),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed("/auth/phone-verification-code", arguments: {
                      "countryCode": countryCode,
                      "phone": phoneTextController.text
                    });
                  },
                  child: const Text(
                    '인증메시지 전송',
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
          ))),
    );
  }
}
