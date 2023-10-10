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
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF343434),
                  child: Text(
                    "Card",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
