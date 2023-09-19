import 'package:flutter/material.dart';

import '../firebase/auth.dart';

class TodoLogin extends StatefulWidget {
  const TodoLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TodoLoginState();
  }
}

class _TodoLoginState extends State<TodoLogin> {
  var loginProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loginProcessing
                  ? const CircularProgressIndicator()
                  : InkWell(
                      onTap: () {
                        setState(() {
                          loginProcessing = true;
                        });
                        signInWithGoogle(context).then((value) {
                          Navigator.of(context).pushReplacementNamed("/");
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.blue,
                          ),
                        ),
                        child: const Text("Sign in with Google"),
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
