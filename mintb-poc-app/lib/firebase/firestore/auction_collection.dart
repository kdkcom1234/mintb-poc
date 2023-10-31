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
