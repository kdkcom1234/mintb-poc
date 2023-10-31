import 'package:flutter/material.dart';
import 'package:mintb_poc_app/firebase/firestore/profile_collection.dart';
import 'package:mintb_poc_app/screens/auction/auction_live_card.dart';

import '../../firebase/firestore/auction_collection.dart';

class AuctionLive extends StatefulWidget {
  const AuctionLive({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuctionLiveState();
  }
}

class _AuctionLiveState extends State<AuctionLive> {
  List<AuctionLiveCard> auctionCardList = [];
  final pageController = PageController();

  Future<void> setAuctionLiveCards() async {
    final auctionList = await fetchAuctionLiveList();
    if (auctionList.isNotEmpty) {
      setState(() {
        auctionCardList = auctionList.map((e) => AuctionLiveCard(e)).toList();
      });

      final firstCardProfile = await fetchProfile(id: auctionList[0].profileId);
      if (firstCardProfile != null) {
        setState(() {
          auctionCardList[0] = AuctionLiveCard(
            auctionList[0],
            profileData: firstCardProfile,
          );
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // auctionCardList.addAll([
    //   const AuctionLiveCard(),
    //   const AuctionLiveCard(),
    //   const AuctionLiveCard()
    // ]);

    setAuctionLiveCards();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  itemCount: auctionCardList.length,
                  itemBuilder: (ctx, index) => auctionCardList[index],
                  controller: pageController,
                ))),
        Center(
            child: Container(
          width: 200,
          color: Colors.cyanAccent,
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          height: 10,
        ))
      ],
    );
  }
}
