import 'package:flutter/material.dart';

class WelcomePrivacy extends StatefulWidget {
  const WelcomePrivacy({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WelcomePrivacyState();
  }
}

class _WelcomePrivacyState extends State<WelcomePrivacy> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Welcome"),
    );
  }
}
