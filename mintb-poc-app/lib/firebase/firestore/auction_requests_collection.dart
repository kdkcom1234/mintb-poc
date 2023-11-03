import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth.dart';

Future<String> createAuctionRequest() async {
  var collectionRef =
      FirebaseFirestore.instance.collection("/auction-requests/");
  final docRef = await collectionRef
      .add({"profileId": getUid(), "createdAt": FieldValue.serverTimestamp()});
  final doc = await docRef.get();
  log(doc.id);
  return doc.id;
}

// 임시로 승인 침
Future<void> confirmAuctionRequest(String auctionRequestId) async {
  final docRef =
      FirebaseFirestore.instance.doc("/auction-requests/$auctionRequestId");
  await docRef.set({"isConfirm": true}, SetOptions(merge: true));
}

Future<void> removeAuctionRequest(String auctionRequestId) async {
  final docRef =
      FirebaseFirestore.instance.doc("/auction-requests/$auctionRequestId");
  await docRef.delete();
}

Future<void> setAuctionRequestLive(String auctionRequestId) async {
  final docRef =
      FirebaseFirestore.instance.doc("/auction-requests/$auctionRequestId");
  await docRef.get();
  docRef.set({"isLive": true}, SetOptions(merge: true));
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getSnapshotAuctionRequest(
    String auctionRequestId) {
  var query =
      FirebaseFirestore.instance.doc('/auction-requests/$auctionRequestId');
  return query.snapshots();
}
