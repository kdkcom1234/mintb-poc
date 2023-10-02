import 'package:flutter/material.dart';

class BackButtonLight extends StatelessWidget {
  const BackButtonLight(this.screenContext, {super.key});
  final BuildContext screenContext;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(screenContext).pop();
        },
        child: const Padding(
          padding: EdgeInsets.only(top: 28, left: 16),
          child: Image(
            image: AssetImage('assets/back_button.png'),
            width: 16,
          ),
        ));
  }
}
