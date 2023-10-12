import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/profile/profile_info.dart';
import 'package:mintb_poc_app/screens/profile/wallet_info.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileMainState();
  }
}

class _ProfileMainState extends State<ProfileMain> {
  final tabs = ["profile", "wallet"];
  var selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: const Color(0xFF1C1C26),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFF343434),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              /* -- 탭 버튼 */
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(
                                        width: 40,
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedTab = 0;
                                              });
                                            },
                                            child: Container(
                                              width: 88,
                                              height: 40,
                                              decoration: ShapeDecoration(
                                                color: selectedTab == 0
                                                    ? const Color(0xFF3DDFCE)
                                                    : const Color(0xFF343434),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF3EDFCF)),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Profile',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selectedTab == 0
                                                      ? const Color(0xFF343434)
                                                      : const Color(0xFF949494),
                                                  fontSize: 16,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedTab = 1;
                                              });
                                            },
                                            child: Container(
                                              width: 88,
                                              height: 40,
                                              decoration: ShapeDecoration(
                                                color: selectedTab == 1
                                                    ? const Color(0xFF3DDFCE)
                                                    : const Color(0xFF343434),
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Color(0xFF3EDFCF)),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(8),
                                                    bottomRight:
                                                        Radius.circular(8),
                                                  ),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Wallet',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selectedTab == 1
                                                      ? const Color(0xFF343434)
                                                      : const Color(0xFF949494),
                                                  fontSize: 16,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: Image.asset(
                                          "assets/setting_icon.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ]),
                              ),
                              selectedTab == 0
                                  ? const ProfileInfo()
                                  : const WalletInfo()
                            ],
                          ),
                        )))
              ],
            ),
          )),
    );
  }
}
