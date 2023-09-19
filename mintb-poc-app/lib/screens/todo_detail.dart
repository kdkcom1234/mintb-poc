import 'package:flutter/material.dart';

import '../firebase/collections/todo_collection.dart';

class TodoDetail extends StatelessWidget {
  const TodoDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("할 일 상세"),
      ),
      body: Center(
        child: Text(
          args["memo"] as String,
          style: const TextStyle(fontSize: 40),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          removeTodoContent(args["id"] as String).then((val) {
            Navigator.of(context).pop({"index": args["index"] as int});
          });
        },
        child: const Icon(Icons.delete_outline),
      ),
    );
  }
}
