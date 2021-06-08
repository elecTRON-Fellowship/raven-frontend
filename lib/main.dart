import 'package:flutter/material.dart';
import 'package:raven/screens/sign_up.dart';
import 'package:raven/screens/user_info.dart';
import './screens/login.dart';

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
      theme: ThemeData(
        primaryColorLight: Color.fromRGBO(194, 222, 232, 1),
        primaryColor: Color.fromRGBO(103, 186, 216, 1),
        primaryColorDark: Color.fromRGBO(63, 163, 199, 1),
        fontFamily: "Poppins",
      ),
      home: LoginScreen(),
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
