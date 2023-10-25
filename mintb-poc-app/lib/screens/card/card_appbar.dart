import 'package:flutter/material.dart';

class CardAppbar extends StatefulWidget {
  const CardAppbar(
      {super.key,
      required this.onRefreshPressed,
      required this.onFilterPressed});
  final VoidCallback onRefreshPressed;
  final VoidCallback onFilterPressed;

  @override
  State<StatefulWidget> createState() {
    return _MainAppbarState();
  }
}

class _MainAppbarState extends State<CardAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 17.6,
      margin: const EdgeInsets.only(top: 15.2, left: 15.2, right: 15.2),
      decoration: const BoxDecoration(color: Color(0xFF343434)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              widget.onRefreshPressed();
            },
            child: Image.asset(
              "assets/refresh_icon.png",
              width: 16.73,
              height: 16,
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  widget.onFilterPressed();
                },
                child: Image.asset(
                  "assets/filter_icon.png",
                  width: 19.2,
                  height: 17.6,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.4),
                child: Image.asset(
                  "assets/noti_icon.png",
                  width: 16.8,
                  height: 17.07,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
