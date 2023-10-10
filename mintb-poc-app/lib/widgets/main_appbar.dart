import 'package:flutter/cupertino.dart';

class MainAppbar extends StatefulWidget {
  const MainAppbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainAppbarState();
  }
}

class _MainAppbarState extends State<MainAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      decoration: const BoxDecoration(color: Color(0xFF1C1C26)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Image.asset(
              "assets/filter_icon.png",
              width: 40,
              height: 40,
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo_login.png",
                    width: 72.4,
                  ),
                ],
              )),
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.only(top: 9.3, bottom: 9.3, right: 4),
            child: Image.asset(
              "assets/notification_icon.png",
              width: 21,
              height: 21.4,
            ),
          )
        ],
      ),
    );
  }
}
