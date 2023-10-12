import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth.dart';

class TodoContentCollection {
  final String id;
  final String memo;
  final Timestamp createdAt;

  TodoContentCollection(this.id, this.memo, this.createdAt);
}

Future<Iterable<TodoContentCollection>> getTodoContents(
    {Timestamp? lastDocTime}) async {
  log(lastDocTime.toString());

  final contents = await FirebaseFirestore.instance
      .collection('todos/${getUid()}/contents')
      .orderBy("createdAt", descending: true) // id 기준 정렬(id해시: timestamp+랜덤)
      .startAfter([
        lastDocTime ??
            Timestamp.fromMillisecondsSinceEpoch(
                DateTime.timestamp().millisecondsSinceEpoch)
      ])
      .limit(3)
      .get();

  for (var element in contents.docs) {
    log(element.data().toString());
  }

  log(contents.docs.length.toString());
  return contents.docs
      .map((e) => TodoContentCollection(e.id, e["memo"], e["createdAt"]));
}

Future<DocumentSnapshot<Map<String, dynamic>>?> createTodoContent(
    String memo) async {
  final contentsRef =
      FirebaseFirestore.instance.collection('todos/${getUid()}/contents');

  DocumentSnapshot<Map<String, dynamic>>? doc;
  try {
    var docRef = await contentsRef
        .add({"memo": memo, "createdAt": FieldValue.serverTimestamp()});
    doc = await docRef.get();
    return doc;
  } catch (e) {
    log(e.toString());
  }
  return doc;
}

Future<void> removeTodoContent(String docId) async {
  final contentsRef =
      FirebaseFirestore.instance.collection('todos/${getUid()}/contents');
  await contentsRef.doc(docId).delete();
}
