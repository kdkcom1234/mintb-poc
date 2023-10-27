import 'package:flutter/material.dart';
import 'package:mintb_poc_app/screens/card/card_main.dart';
import 'package:mintb_poc_app/screens/profile/profile_main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;

  var currentIndex = 0;

  void changeTabsIndex(int index) {
    setState(() {
      controller.index = index;
    });
  }

  void handleTabChanging() {
    setState(() {
      currentIndex = controller.index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(handleTabChanging);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [CardMain(), ProfileMain()],
      ),
      bottomNavigationBar: Container(
        height: 48,
        color: const Color(0xFF1C1C26),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  changeTabsIndex(0);
                },
                child: Image.asset(
                  currentIndex == 0
                      ? "assets/tabbar_card_icon_active.png"
                      : "assets/tabbar_card_icon.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Image.asset(
                  "assets/tabbar_discover_icon.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Image.asset(
                  "assets/tabbar_collection_icon.png",
                  width: 72,
                  height: 48,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Image.asset(
                  "assets/tabbar_chat_icon.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  changeTabsIndex(1);
                },
                child: Image.asset(
                  currentIndex == 1
                      ? "assets/tabbar_profile_icon_active.png"
                      : "assets/tabbar_profile_icon.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
