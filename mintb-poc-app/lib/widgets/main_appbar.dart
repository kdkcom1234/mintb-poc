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
    );
  }
}
