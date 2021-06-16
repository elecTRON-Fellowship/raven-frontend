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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
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
              Navigator.of(context)
                  .pushNamed('/contacts')
                  .then((_) => setState(() {}));
            },
            icon: Icon(Icons.add_circle_outline_rounded),
            iconSize: 30,
            color: Theme.of(context).primaryColorDark,
          ),
        ],
      ),

      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _conversationsCollection
              .where('members', arrayContains: _auth.currentUser!.uid)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final documents = (snapshot.data)!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) => ConversationCard(
                  friendUserId:
                      documents[index]['members'][0] == _auth.currentUser!.uid
                          ? documents[index]['members'][1]
                          : documents[index]['members'][0],
                  unreadTexts: documents[index]['unreadTexts'] as int,
                  conversationId: documents[index].id,
                ),
              );
            } else {
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
