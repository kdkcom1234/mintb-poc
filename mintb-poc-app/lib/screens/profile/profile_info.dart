import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileInfoState();
  }
}

class _ProfileInfoState extends State<ProfileInfo> {
  var samples = [
    {
      "image": "assets/profile_card_sample_female.png",
      "info": "Otoo, 29",
      "spec": "Influencer, 168cm, Curvy"
    },
    {
      "image": "assets/profile_sample.png",
      "info": "John, 32",
      "spec": "Surgeon General, 185cm, muscular"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                clipBehavior: Clip.antiAlias,
                decoration: const ShapeDecoration(
                  color: Color(0xFFD9D9D9),
                  shape: OvalBorder(),
                ),
                child: Image.asset(
                  samples[0]["image"]!,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: Text(
              samples[0]["info"]!,
              style: const TextStyle(
                color: Color(0xFF3DDFCE),
                fontSize: 24,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
          Text(
            samples[0]["spec"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFDADADA),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/location_icon.png",
                  width: 10,
                  height: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  'New York',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0x99D2D2D2),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: Container(
                  height: 64,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF484848),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hot Score',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFDADADA),
                            fontSize: 20,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        Text(
                          '2700',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFDE5854),
                            fontSize: 20,
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                  ))),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: 64,
                decoration: ShapeDecoration(
                  color: const Color(0xFF484848),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text(
                              'Mint',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFDADADA),
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: ShapeDecoration(
                              color: const Color(0xE53DDFCE),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            child: const Text(
                              '+',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Text(
                        '4700',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3DDFCE),
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
