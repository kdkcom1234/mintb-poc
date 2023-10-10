import 'package:flutter/material.dart';

class WalletInfo extends StatefulWidget {
  const WalletInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WalletInfoState();
  }
}

class _WalletInfoState extends State<WalletInfo> {
  var address = "0x4F...3B40";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
      child: Column(
        children: [
          Container(
            height: 48,
            decoration: ShapeDecoration(
              color: const Color(0xFF484848),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFDADADA),
                      fontSize: 16,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                  Text(
                    address,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF3DDFCE),
                      fontSize: 16,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
