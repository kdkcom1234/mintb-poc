import 'package:flutter/material.dart';

class BackNavButton extends StatelessWidget {
  const BackNavButton(this.screenContext,
      {super.key, this.padding = const EdgeInsets.only(top: 5, left: 5)});
  final BuildContext screenContext;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(screenContext).pop();
        },
        child: Padding(
          padding: padding,
          child: const Image(
            image: AssetImage('assets/back_button.png'),
            width: 38,
          ),
        ));
  }
}
