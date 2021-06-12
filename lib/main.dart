import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven/providers/user.dart';
import 'package:raven/screens/chat.dart';
import 'package:raven/screens/conversations.dart';
import 'package:raven/screens/sign_up.dart';
import 'package:raven/screens/splash_screen.dart';
import 'package:raven/screens/tickets.dart';
import 'package:raven/screens/user_info.dart';
import 'package:raven/screens/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => User(),
      child: Consumer<User>(
        builder: (context, user, child) => MaterialApp(
          title: 'Raven',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColorLight: Color.fromRGBO(194, 222, 232, 1),
            primaryColor: Color.fromRGBO(103, 186, 216, 1),
            primaryColorDark: Color.fromRGBO(63, 163, 199, 1),
            fontFamily: "Poppins",
          ),
          // home: user.getUser['authToken'] != null
          //     ? ConversationsScreen()
          //     : FutureBuilder(
          //         future: user.tryAutoLogin(),
          //         builder: (context, snapshot) =>
          //             snapshot.connectionState == ConnectionState.waiting
          //                 ? SplashScreen()
          //                 : LoginScreen(),
          //       ),
          home: TicketsScreen(),
          routes: {
            '/login': (ctx) => LoginScreen(),
            '/signup': (ctx) => SignUpScreen(),
            '/user-info': (ctx) => UserInfoScreen(),
            '/conversations': (ctx) => ConversationsScreen(),
            '/chat': (ctx) => ChatScreen()
          },
        ),
      ),
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
