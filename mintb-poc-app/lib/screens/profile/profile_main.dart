import 'package:flutter/material.dart';
import 'package:mintb_poc_app/widgets/main_appbar.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileMainState();
  }
}

class _ProfileMainState extends State<ProfileMain> {
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
                    "Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
