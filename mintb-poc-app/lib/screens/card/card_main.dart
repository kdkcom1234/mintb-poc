import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/main_appbar.dart';

class CardMain extends StatefulWidget {
  const CardMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CardMainState();
  }
}

class _CardMainState extends State<CardMain> {
  var samples = [
    {
      "image": "assets/profile_card_sample.png",
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
    return Scaffold(
      body: Container(
          color: const Color(0xFF1C1C26),
          child: SafeArea(
            child: Column(
              children: [
                const MainAppbar(),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(25),
                  color: const Color(0xFF343434),
                  child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xE53DDFCE),
                            blurRadius: 0,
                            offset: Offset(4, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Image.asset(
                              samples[0]["image"]!,
                              fit: BoxFit.cover,
                            ),
                          )),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 50,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF1C1C26),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15, left: 16),
                                          child: Text(
                                            samples[0]["info"]!,
                                            style: const TextStyle(
                                              color: Color(0xFF3DDFCE),
                                              fontSize: 24,
                                              fontFamily: "Pretendard",
                                              fontWeight: FontWeight.w700,
                                              // height: 0,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, left: 16, bottom: 15),
                                          child: Text(
                                            //Surgeon General, 185cm, muscular
                                            samples[0]["spec"]!,
                                            style: const TextStyle(
                                              color: Color(0x99D2D2D2),
                                              fontSize: 14,
                                              fontFamily: "Pretendard",
                                              fontWeight: FontWeight.w600,
                                              // height: 0,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ))
              ],
            ),
          )),
    );
  }
}
