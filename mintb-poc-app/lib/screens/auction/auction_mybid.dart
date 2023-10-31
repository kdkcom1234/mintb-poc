import 'package:flutter/cupertino.dart';

class AuctionMyBid extends StatefulWidget {
  const AuctionMyBid({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionMyBidState();
  }
}

class _AuctionMyBidState extends State<AuctionMyBid> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("내입찰"),
    );
  }
}
