import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintb_poc_app/firebase/auth.dart';

class AuctionCollection {
  String? id;
  final String profileId;
  Timestamp? duration;
  Timestamp? createdAt;
  bool isLive;

  AuctionCollection(this.profileId, this.duration, this.isLive,
      {this.id, this.createdAt});
}

class AuctionBidCollection {
  final int amount;
  String id;
  Timestamp? createdAt;

  AuctionBidCollection(this.amount, {required this.id, this.createdAt});
}

Future<List<AuctionCollection>> fetchAuctionLiveList() async {
  var query = FirebaseFirestore.instance
      .collection('auctions')
      .where('isLive', isEqualTo: true)
      .orderBy("createdAt", descending: true);

  final collection = await query.get();

  List<AuctionCollection> list = [];
  for (final doc in collection.docs) {
    final data = doc.data();
    final auctionId = doc.id;
    list.add(AuctionCollection(
        data["profileId"], data["duration"], data["isLive"],
        id: auctionId, createdAt: data["createdAt"]));
  }
  return list;
}

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctionBids(
    String auctionId) {
  var query = FirebaseFirestore.instance
      .collection('auctions/$auctionId/bids')
      .orderBy("amount", descending: true);
  return query.snapshots();
}

Future<void> createAuctionBid(String auctionId, int amount) async {
  // 서버 사이드 로직 처리(트리거 이용)
  var docRef = FirebaseFirestore.instance
      .doc('auctions/$auctionId/bid-requests/${getUid()}');
  await docRef
      .set({"amount": amount, "createdAt": FieldValue.serverTimestamp()});

  // // 클라이언트 사이드 로직 처리(POC용)
  // await usePoints(amount);
  // var docRef = FirebaseFirestore.instance
  //     .doc('auctions/$auctionId/bids/${getUid()}');
  // await docRef
  //     .set({"amount": amount, "createdAt": FieldValue.serverTimestamp()});
}
