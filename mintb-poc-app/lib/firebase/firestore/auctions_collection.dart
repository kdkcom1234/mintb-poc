import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mintb_poc_app/firebase/auth.dart';
import 'package:mintb_poc_app/firebase/firestore/profiles_collection.dart';

class AuctionCollection {
  String? id;
  final String profileId;
  ProfileCollection? profile;
  Timestamp? duration;
  Timestamp? createdAt;
  Timestamp? endedAt;
  bool isLive;
  bool? isConfirm;
  List<AuctionBidCollection>? bids;
  List<String>? views;

  AuctionCollection(this.profileId, this.duration, this.isLive,
      {this.id,
      this.createdAt,
      this.endedAt,
      this.isConfirm,
      this.bids,
      this.views,
      this.profile});
}

class AuctionBidCollection {
  final int amount;
  String id;
  String? uid;
  ProfileCollection? profile;
  Timestamp? createdAt;

  AuctionBidCollection(this.amount,
      {required this.id, this.createdAt, this.uid, this.profile});
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

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctions() {
  var query = FirebaseFirestore.instance
      .collection('auctions')
      .orderBy("createdAt", descending: true);
  return query.snapshots();
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getSnapshotAuction(
    String auctionId) {
  return FirebaseFirestore.instance.doc('auctions/$auctionId').snapshots();
}

Future<AuctionCollection?> fetchAuctionLive(String auctionId) async {
  var doc = await FirebaseFirestore.instance.doc('auctions/$auctionId').get();

  final data = doc.data();
  if (data == null) {
    return null;
  }

  return AuctionCollection(data["profileId"], data["duration"], data["isLive"],
      id: auctionId, createdAt: data["createdAt"]);
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
      .doc('/auctions/$auctionId/bid-requests/${getUid()}');
  await docRef
      .set({"amount": amount, "createdAt": FieldValue.serverTimestamp()});
}

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctionRequestLive(
    String auctionRequestId) {
  var query = FirebaseFirestore.instance
      .collection("auctions")
      .where("auctionRequestId", isEqualTo: auctionRequestId);
  return query.snapshots();
}

Future<void> upViewCount(String auctionId) async {
  var docRef =
      FirebaseFirestore.instance.doc('auctions/$auctionId/views/${getUid()}');
  await docRef.set({});
}

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotAuctionViews(
    String auctionId) {
  var query =
      FirebaseFirestore.instance.collection('auctions/$auctionId/views');
  return query.snapshots();
}

Future<void> endAuction(String auctionId) async {
  var docRef = FirebaseFirestore.instance.doc('auctions/$auctionId');
  await docRef.set(
      {"status": 1, "isLive": false, "endedAt": FieldValue.serverTimestamp()},
      SetOptions(merge: true));
}

Future<void> requestAuctionRewards(String auctionId) async {
  var docRef = FirebaseFirestore.instance.doc('auctions/$auctionId');
  await docRef.set({"status": 2}, SetOptions(merge: true));
}

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotMyAuctions() {
  var query = FirebaseFirestore.instance
      .collection("auctions")
      .where("profileId", isEqualTo: getUid())
      .orderBy("createdAt", descending: true);
  return query.snapshots();
}

Future<List<AuctionBidCollection>> fetchAuctionBids(String auctionId) async {
  var collection = await FirebaseFirestore.instance
      .collection('auctions/$auctionId/bids')
      .orderBy("amount", descending: true)
      .get();

  return collection.docs
      .map((e) => AuctionBidCollection(e.data()["amount"],
          id: e.id, createdAt: e.data()["createdAt"]))
      .toList();
}

Future<List<String>> fetchAuctionViews(String auctionId) async {
  var collection = await FirebaseFirestore.instance
      .collection('auctions/$auctionId/views')
      .get();

  return collection.docs.map((e) => e.id).toList();
}

Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotMyBids() {
  // 'bids' 컬렉션 그룹에 대한 쿼리를 생성합니다.
  return FirebaseFirestore.instance
      .collectionGroup('bids')
      .where("uid", isEqualTo: getUid())
      .orderBy("createdAt", descending: true)
      .snapshots();
}
