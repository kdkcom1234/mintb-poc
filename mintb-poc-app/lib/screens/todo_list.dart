import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/auth.dart';
import '../firebase/firestore/todo_collection.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoListState();
  }
}

class _TodoListState extends State<TodoList> {
  List<TodoContentCollection> todoList = List.empty(growable: true);
  Timestamp? lastDocTime;

  getTodos() async {
    final contents = await getTodoContents(lastDocTime: lastDocTime);

    setState(() {
      if (contents.isNotEmpty) {
        lastDocTime = contents.last.createdAt;
        // todoList.clear();
        todoList.addAll(contents);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (getUid() != "") {
      setState(() {
        getTodos();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Center(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Card(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      todoList[index].memo,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushNamed("/detail", arguments: {
                      "memo": todoList[index].memo,
                      "id": todoList[index].id,
                      "index": index
                    }) as Map<String, dynamic>;

                    setState(() {
                      todoList.removeAt(index);
                    });
                  },
                ),
              ),
              itemCount: todoList.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      getTodos();
                    },
                    child: const Text("more"))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 10),
            child: Row(
              children: [
                TextButton(
                    onPressed: () {
                      signOut().then((value) => {
                            Navigator.of(context).pushReplacementNamed("/login")
                          });
                    },
                    child: const Text("Log out")),
                Text(FirebaseAuth.instance.currentUser == null
                    ? ""
                    : FirebaseAuth.instance.currentUser?.email as String)
              ],
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed("/form")
              as Map<String, dynamic>;
          setState(() {
            todoList.insert(
                0,
                TodoContentCollection(
                    result["id"], result["memo"], result["createdAt"]));
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
