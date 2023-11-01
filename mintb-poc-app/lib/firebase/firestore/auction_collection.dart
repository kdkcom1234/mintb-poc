import 'package:cloud_firestore/cloud_firestore.dart';

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
  String id;
  final int amount;
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

// Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctionMaxBidAmount(
//     String auctionId) {
//   return FirebaseFirestore.instance
//       .collection('auctions/$auctionId/bids')
//       .orderBy("amount", descending: true)
//       .limit(1)
//       .snapshots();
// }

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctionBids(
    String auctionId) {
  var query = FirebaseFirestore.instance
      .collection('auctions/$auctionId/bids')
      .orderBy("amount", descending: true);

  return query.snapshots();
}
