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
                  padding: const EdgeInsets.only(
                      left: 25, top: 25, right: 25, bottom: 25),
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
                                margin: const EdgeInsets.only(
                                    left: 0.5, right: 0.5),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        left: -22,
                                        top: -10,
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Image.asset(
                                            "assets/profile_image_sample.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                  ],
                                )),
                          ),
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
                                child: const Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 15, left: 16),
                                          child: Text(
                                            'Otoo, 29',
                                            style: TextStyle(
                                              color: Color(0xFF3DDFCE),
                                              fontSize: 24,
                                              fontFamily: 'Inter',
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
                                          padding: EdgeInsets.only(
                                              top: 8, left: 16, bottom: 15),
                                          child: Text(
                                            'Influencer, 168cm, Curvy',
                                            style: TextStyle(
                                              color: Color(0x99D2D2D2),
                                              fontSize: 14,
                                              fontFamily: 'Inter',
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
