import 'package:flutter/material.dart';

import '../firebase/firestore/todo_collection.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoFormState();
  }
}

class _TodoFormState extends State<TodoForm> {
  var input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("할 일 등록"),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(child: TextField(controller: input)),
                    ElevatedButton(
                        onPressed: () {
                          createTodoContent(input.text).then((doc) {
                            if (doc != null) {
                              Navigator.of(context).pop({
                                "id": doc.id,
                                "memo": doc["memo"],
                                "createdAt": doc["createdAt"]
                              });
                            }
                          });
                        },
                        child: const Text("저장하기"))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
