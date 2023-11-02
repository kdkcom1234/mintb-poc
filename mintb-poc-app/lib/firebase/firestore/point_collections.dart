import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth.dart';

class PointCollection {
  String? id;
  int mint;

  PointCollection({required this.mint, this.id});
}

Future<PointCollection?> fetchPoints() async {
  final pointDoc = await FirebaseFirestore.instance
      .collection('points')
      .doc("/${getUid()}")
      .get();

  if (pointDoc.exists && pointDoc.data() != null) {
    return PointCollection(mint: pointDoc.data()!["mint"], id: pointDoc.id);
  }

  return null;
}

Future<Record> usePoints(int amount) async {
  final pointData = await fetchPoints();
  if (pointData == null || pointData!.mint == 0) {
    return (false, "no points");
  }

  if (pointData.mint - amount < 0) {
    return (false, "not enough points");
  }

  final pointRef =
      FirebaseFirestore.instance.collection('points').doc("/${getUid()}");

  await pointRef.set({"mint": pointData!.mint - amount});
  return (false, "no point");
}
