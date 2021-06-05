import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/conversation_card.dart';

class Conversations extends StatelessWidget {
  // const Conversations({Key? key}) : super(key: key);

  final List<Map<String, Object>> _conversations = [
    {
      'name': 'Zaid Sheikh',
      'lastText': 'Call me back ASAP. ASAP. ASAP.',
      'unreadTexts': 0,
      'time': '13:15'
    },
    {
      'name': 'Mizan Ali',
      'lastText': "Let's hang out soon!",
      'unreadTexts': 2,
      'time': '13:15'
    },
    {
      'name': 'Neel Modi',
      'lastText': "What's up bro?",
      'unreadTexts': 21,
      'time': '13:15'
    },
    {
      'name': 'Max Verstappen',
      'lastText': "I'm moving to Ferrari next season.",
      'unreadTexts': 45,
      'time': '13:15'
    },
    {
      'name': 'Charles Leclerc',
      'lastText': "Pole position this week. Watch.",
      'unreadTexts': 12,
      'time': '13:15'
    },
    {
      'name': 'Sebastian Vettel',
      'lastText': 'I hate my team. No cap.',
      'unreadTexts': 2,
      'time': '13:15'
    },
    {
      'name': 'Lewis Hamilton',
      'lastText': 'Lunch tomorrow?.',
      'unreadTexts': 0,
      'time': '13:15'
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        color: Theme.of(context).primaryColor)),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search_rounded),
                  iconSize: 30,
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_rounded),
                  iconSize: 34.5,
                  color: Theme.of(context).primaryColor,
                )
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: _conversations
              .map((item) => ConversationCard(
                  (item['name'] as String),
                  (item['lastText'] as String),
                  (item['unreadTexts'] as int),
                  (item['time'] as String)))
              .toList(),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Theme.of(context).primaryColor,
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
