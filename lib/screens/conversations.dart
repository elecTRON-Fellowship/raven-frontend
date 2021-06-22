import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/common/end_drawer.dart';
import 'package:uuid/uuid.dart';

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

  int _selectedNavBarIndex = 0;

  void _onIndexChanged(index, ctx) {
    setState(() {
      _selectedNavBarIndex = index;
      print(_selectedNavBarIndex);
    });
    if (_selectedNavBarIndex == 1) {
      Navigator.of(context).pushNamed('/tickets');
      setState(() {
        _selectedNavBarIndex = 0;
      });
    }
    if (_selectedNavBarIndex == 3) {
      print("This is running");
      Scaffold.of(ctx).openEndDrawer();
      setState(() {
        _selectedNavBarIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      title: Text(
        'Conversations',
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).primaryColorDark)),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search_rounded),
          iconSize: 25,
          color: Theme.of(context).primaryColorDark,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/contacts');
          },
          icon: Icon(Icons.add_circle_outline_rounded),
          iconSize: 25,
          color: Theme.of(context).primaryColorDark,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: appBar,
      body: Container(
        height: size.height - appBar.preferredSize.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: theme.backgroundColor,
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _conversationsCollection
              .where('members', arrayContains: _auth.currentUser!.uid)
              // .where('lastTime', isNotEqualTo: null)
              .orderBy('lastTime', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final documents = (snapshot.data)!.docs;
              if (documents.isNotEmpty) {
                return ListView.builder(
                  key: ValueKey(Uuid().v4()),
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
                return Center(
                  child: Text(
                    'No conversations found.\nClick on the + icon to start one.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColorDark)),
                  ),
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ),
      endDrawer: EndDrawer(),
      bottomNavigationBar: Builder(
        builder: (ctx) => BottomNavigationBar(
          elevation: 2,
          currentIndex: _selectedNavBarIndex,
          onTap: (index) => _onIndexChanged(index, ctx),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: theme.primaryColor,
          selectedItemColor: theme.primaryColorDark,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
                size: 30,
              ),
              label: 'Conversations',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 30,
              ),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_taxi_rounded,
                size: 30,
              ),
              label: 'Uber',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_rounded,
                size: 30,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
