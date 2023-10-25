import 'package:flutter/material.dart';
import 'package:mintb_poc_app/preferences/profile_local.dart';
import 'package:mintb_poc_app/screens/card/card_appbar.dart';
import 'package:mintb_poc_app/screens/card/card_empty.dart';
import 'package:mintb_poc_app/screens/card/card_filter.dart';

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
      "image": "assets/profile_card_sample_female2.png",
      "info": "Otoo, 29",
      "spec": "Influencer, 168cm"
    },
    {
      "image": "assets/profile_card_sample_male.jpg",
      "info": "V, 27",
      "spec": "Surgeon General, 185cm"
    },
  ];
  var selectedIndex = 1;
  var loading = true;
  var empty = false;

  Future<void> setCard() async {
    setState(() {
      loading = true;
    });
    final profileLocal = await getProfileLocal();
    if (profileLocal != null) {
      setState(() {
        selectedIndex = profileLocal.gender == 0 ? 1 : 0;
      });
    }

    setState(() {
      loading = false;
    });
  }

  void handleRefreshPressed() {
    setState(() {
      empty = !empty;
    });
  }

  void handleFilterPressed() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const CardFilter(),
      fullscreenDialog: true,
    ));
    setState(() {
      empty = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xFF343434),
          child: SafeArea(
            child: Column(
              children: [
                CardAppbar(
                  onRefreshPressed: handleRefreshPressed,
                  onFilterPressed: handleFilterPressed,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.only(
                      left: 18, right: 18, top: 18.2, bottom: 20),
                  color: const Color(0xFF343434),
                  child: loading
                      ? const SizedBox.shrink()
                      : empty
                          ? CardEmpty(
                              onFilterPressed: handleFilterPressed,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      samples[selectedIndex]["image"]!),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 38,
                                    left: 18,
                                    child: SizedBox(
                                      height: 51,
                                      width: MediaQuery.of(context).size.width -
                                          62,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                samples[selectedIndex]["info"]!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700,
                                                  height: 0,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 1.0,
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.60),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                samples[selectedIndex]["spec"]!,
                                                style: const TextStyle(
                                                  color: Color(0xFFD5DBDB),
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 1.0,
                                                      color: Colors.black,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Image.asset(
                                                "assets/check_badge.png",
                                                width: 20,
                                                height: 20.15,
                                              ),
                                              const SizedBox(
                                                width: 9,
                                              ),
                                              Image.asset(
                                                "assets/profile_badge.png",
                                                width: 20,
                                                height: 20.98,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                ))
              ],
            ),
          )),
    );
  }
}
