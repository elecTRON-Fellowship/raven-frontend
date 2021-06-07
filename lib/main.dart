import 'package:flutter/material.dart';

import 'screens/conversations.dart';
// import 'screens/chat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raven',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color.fromRGBO(63, 163, 199, 1.0)),
      home: ConversationsScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raven'),
      ),
      body: Text('Hello World'),
    );
  }
}
