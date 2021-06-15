import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/conversations_screen/conversation_card.dart';

class ConversationsScreen extends StatefulWidget {
  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');

  bool showLoading = false;

  // final List<Map<String, Object>> _conversations = [
  //   {
  //     'name': 'Zaid Sheikh',
  //     'lastText': 'Call me back ASAP. ASAP. ASAP.',
  //     'unreadTexts': 0,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Mizan Ali',
  //     'lastText': "Let's hang out soon!",
  //     'unreadTexts': 2,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Neel Modi',
  //     'lastText': "What's up bro?",
  //     'unreadTexts': 21,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Max Verstappen',
  //     'lastText': "I'm moving to Ferrari next season.",
  //     'unreadTexts': 45,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Charles Leclerc',
  //     'lastText': "Pole position this week. Watch.",
  //     'unreadTexts': 12,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Sebastian Vettel',
  //     'lastText': 'I hate my team. No cap.',
  //     'unreadTexts': 2,
  //     'time': '13:15'
  //   },
  //   {
  //     'name': 'Lewis Hamilton',
  //     'lastText': 'Lunch tomorrow?.',
  //     'unreadTexts': 0,
  //     'time': '13:15'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(194, 222, 232, 1.0),
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Conversations',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Theme.of(context).primaryColorDark)),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded),
                  iconSize: 30,
                  color: Theme.of(context).primaryColorDark,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/contacts');
                  },
                  icon: Icon(Icons.add_circle_outline_rounded),
                  iconSize: 30,
                  color: Theme.of(context).primaryColorDark,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        // child: ListView.builder(
        //   itemCount: _conversations.length,
        //   itemBuilder: (ctx, index) => ConversationCard(
        //       (_conversations[index]['name'] as String),
        //       (_conversations[index]['lastText'] as String),
        //       (_conversations[index]['unreadTexts'] as int),
        //       (_conversations[index]['time'] as String)),
        // ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _conversationsCollection
              .where('members', arrayContains: _auth.currentUser!.uid)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final documents = (snapshot.data)!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) => ConversationCard(
                  documents[index]['members'][0] == _auth.currentUser!.uid
                      ? documents[index]['members'][1]
                      : documents[index]['members'][0],
                  documents[index]['lastText'],
                  int.parse(documents[index]['unreadTexts']),
                  documents[index]['time'],
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Something went wrong.',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
              return Container();
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) async {
              if (index == 1) Navigator.of(context).pushNamed('/tickets');
              if (index == 3) {
                await _auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/auth', (route) => false);
              }
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).primaryColorDark,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                icon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: Color.fromRGBO(194, 222, 232, 1.0),
                ),
                label: 'Conversations',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 30,
                  color: Color.fromRGBO(194, 222, 232, 1.0),
                ),
                label: 'Tickets',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_taxi_rounded,
                  size: 30,
                  color: Color.fromRGBO(194, 222, 232, 1.0),
                ),
                label: 'Uber',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_rounded,
                  size: 30,
                  color: Color.fromRGBO(194, 222, 232, 1.0),
                ),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
