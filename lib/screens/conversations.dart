import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/conversation_card.dart';

class Conversations extends StatelessWidget {
  // const Conversations({Key? key}) : super(key: key);

  final List<Map<String, Object>> _conversations = [
    {
      'name': 'Zaid Sheikh',
      'lastText': 'Call me back ASAP. ASAP. ASAP.',
      'unreadTexts': 2,
    },
    {
      'name': 'Mizan Ali',
      'lastText': "Let's hang out soon!",
      'unreadTexts': 2,
    },
    {
      'name': 'Neel Modi',
      'lastText': "What's up bro?",
      'unreadTexts': 2,
    },
    {
      'name': 'Max Verstappen',
      'lastText': "I'm moving to Ferrari next season.",
      'unreadTexts': 2,
    },
    {
      'name': 'Charles Leclerc',
      'lastText': "Pole position this week. Watch.",
      'unreadTexts': 2,
    },
    {
      'name': 'Zaid Sheikh',
      'lastText': 'Call me back ASAP.',
      'unreadTexts': 2,
    },
    {
      'name': 'Mizan Ali',
      'lastText': 'Call me back ASAP.',
      'unreadTexts': 2,
    },
    {
      'name': 'Neel Modi',
      'lastText': 'Call me back ASAP.',
      'unreadTexts': 2,
    },
    {
      'name': 'Max Verstappen',
      'lastText': 'Call me back ASAP.',
      'unreadTexts': 2,
    },
    {
      'name': 'Charles Leclerc',
      'lastText': 'Call me back ASAP.',
      'unreadTexts': 2,
    },
  ];

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
              flexibleSpace: Container(),
              title: Text(
                'Conversations',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Color.fromRGBO(63, 163, 199, 1.0))),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded),
                  iconSize: 28.0,
                  color: Color.fromRGBO(63, 163, 199, 1.0),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_rounded),
                  iconSize: 28.0,
                  color: Color.fromRGBO(63, 163, 199, 1.0),
                )
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: _conversations
              .map((item) => ConversationCard((item['name'] as String),
                  (item['lastText'] as String), (item['unreadTexts'] as int)))
              .toList(),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Color.fromRGBO(63, 163, 199, 1.0),
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
    );
  }
}
