import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/points_collections.dart';

import '../../preferences/profile_local.dart';

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

  ProfileLocal? _profile;
  Future<void> loadProfile() async {
    final localProfile = await getProfileLocal();
    if (localProfile != null) {
      setState(() {
        _profile = localProfile;
      });
    }
  }

  PointCollection? _point;
  Future<void> loadPoint() async {
    final point = await fetchPoints();
    if (point != null) {
      setState(() {
        _point = point;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfile();
    loadPoint();
  }

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
                child: Image.network(
                  _profile != null
                      ? _profile!.images[0]
                      : "https://placehold.co/400x400/png",
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: Text(
              _profile != null ? '${_profile!.nickname}, ${_profile!.age}' : "",
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
            _profile != null ? samples[_profile!.gender]["spec"]! : "",
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
              padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
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
              padding: const EdgeInsets.only(left: 24, right: 24),
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
                      Text(
                        _point != null ? _point!.mint.toString() : "-",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
