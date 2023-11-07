import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth.dart';

class PointCollection {
  String? id;
  int mint;
  int? pop;

  PointCollection({required this.mint, this.id, this.pop});
}

Future<PointCollection?> fetchPoints() async {
  final pointDoc = await FirebaseFirestore.instance
      .collection('points')
      .doc("/${getUid()}")
      .get();

  if (pointDoc.exists && pointDoc.data() != null) {
    return PointCollection(
        mint: pointDoc.data()!["mint"] ?? 0,
        id: pointDoc.id,
        pop: pointDoc.data()!["pop"]);
  }

  return null;
}
