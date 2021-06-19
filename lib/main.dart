import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:raven/screens/contacts.dart';
import 'package:raven/screens/conversations.dart';
import 'package:raven/screens/create_wallet_user_details.dart';
import 'package:raven/screens/friend_transactions.dart';
import 'package:raven/screens/auth.dart';
import 'package:raven/screens/tickets.dart';

import 'screens/address_details_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raven',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(255, 255, 254, 1),
        accentColor: Color.fromRGBO(61, 169, 252, 1),
        primaryColor: Color.fromRGBO(144, 180, 206, 1),
        primaryColorDark: Color.fromRGBO(9, 64, 103, 1),
        fontFamily: "Poppins",
      ),
      home: HomePageRedirect(),
      routes: {
        '/auth': (ctx) => AuthScreen(),
        '/conversations': (ctx) => ConversationsScreen(),
        '/contacts': (ctx) => ContactsScreen(),
        '/tickets': (ctx) => TicketsScreen(),
      },
    );
  }
}

class HomePageRedirect extends StatefulWidget {
  const HomePageRedirect({Key? key}) : super(key: key);

  @override
  _HomePageRedirectState createState() => _HomePageRedirectState();
}

class _HomePageRedirectState extends State<HomePageRedirect> {
  late FirebaseAuth _auth;
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) =>
      _user == null ? AuthScreen() : TicketsScreen();
}
