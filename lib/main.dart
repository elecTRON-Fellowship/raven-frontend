import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raven/providers/user.dart';
import 'package:raven/screens/chat.dart';
import 'package:raven/screens/contacts.dart';
import 'package:raven/screens/conversations.dart';
import 'package:raven/screens/friend_transactions.dart';
import 'package:raven/screens/login_new.dart';
import 'package:raven/screens/otp_screen.dart';
import 'package:raven/screens/sign_up_new.dart';
import 'package:raven/screens/splash_screen.dart';
import 'package:raven/screens/tickets.dart';
import 'package:raven/screens/timed_chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
            backgroundColor: Color.fromRGBO(255, 255, 254, 1),
            accentColor: Color.fromRGBO(61, 169, 252, 1),
            primaryColor: Color.fromRGBO(144, 180, 206, 1),
            primaryColorDark: Color.fromRGBO(9, 64, 103, 1),
            fontFamily: "Poppins",
          ),
          home: user.getUser['authToken'] != null
              ? ConversationsScreen()
              : FutureBuilder(
                  future: user.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreenNew(),
                ),
          routes: {
            '/login': (ctx) => LoginScreenNew(),
            '/signup': (ctx) => SignUpScreenNew(),
            '/otp': (ctx) => OTPScreen(),
            '/conversations': (ctx) => ConversationsScreen(),
            '/contacts': (ctx) => ContactsScreen(),
            '/chat': (ctx) => ChatScreen(),
            '/timed-chat': (ctx) => TimedChatScreen(),
            '/tickets': (ctx) => TicketsScreen(),
            '/friend-transactions': (ctx) => FriendTransactionsScreen()
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
