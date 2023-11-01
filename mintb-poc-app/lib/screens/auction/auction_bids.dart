import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../firebase/firestore/auction_collection.dart';
import '../../firebase/firestore/profile_collection.dart';
import '../../widgets/closeable_titled_appbar.dart';

class AuctionBids extends StatefulWidget {
  const AuctionBids(this.auctionId, {super.key});
  final String auctionId;

  @override
  State<StatefulWidget> createState() {
    return _AuctionBidsState();
  }
}

class _AuctionBidsState extends State<AuctionBids> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      auctionBidsSubscription;
  final List<AuctionBidCollection> bidsList = [];
  final List<ProfileCollection> profileList = [];

  void listenAuctionBids() {
    auctionBidsSubscription =
        getSnapshotAuctionBids(widget.auctionId).listen((event) {
      // 입찰목록 조회
      setState(() {
        bidsList.clear();
        if (event.docs.isNotEmpty) {
          for (var bid in event.docs) {
            bidsList
                .add(AuctionBidCollection(bid.data()["amount"], id: bid.id));
          }
        }
      });

      setProfiles();
    });
  }

  void setProfiles() async {
    final profiles =
        await fetchProfilesByIds(bidsList.map((e) => e.id!).toList());

    setState(() {
      profileList.clear();
      for (final profile in profiles) {
        profileList.add(profile);
      }
    });
  }

  @override
  void dispose() {
    auctionBidsSubscription?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenAuctionBids();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: const Color(0xFF1C1C26),
            child: SafeArea(
              child: Column(
                children: [
                  // 상단 바
                  const CloseableTitledAppbar("입찰 상세 내역"),
                  Expanded(
                    child: Container(
                      color: const Color(0xFF343434),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '총 ${bidsList.length}건',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Expanded(
                              child: ListView.builder(
                                  itemCount: bidsList.length,
                                  itemBuilder: (ctx, index) => Container(
                                        margin: index != 0
                                            ? const EdgeInsets.only(top: 16)
                                            : EdgeInsets.zero,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 78,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFF1C1C26),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: ShapeDecoration(
                                                    image: profileList
                                                            .isNotEmpty
                                                        ? DecorationImage(
                                                            image: NetworkImage(
                                                                profileList
                                                                    .firstWhere((e) =>
                                                                        e.id! ==
                                                                        bidsList[index]
                                                                            .id)
                                                                    .images[0]),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                    shape: const OvalBorder(),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  profileList.isNotEmpty
                                                      ? profileList
                                                          .firstWhere((e) =>
                                                              e.id! ==
                                                              bidsList[index]
                                                                  .id)
                                                          .nickname
                                                      : "",
                                                  style: const TextStyle(
                                                    color: Color(0xFFD5DBDB),
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${bidsList[index].amount} m',
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(
                                                    color: Color(0xFF3EDFCF),
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w700,
                                                    height: 0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
