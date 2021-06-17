import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/friend_ticket_icon.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributors.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  bool _showContributors = false;

  void _setShowContributorsToTrue() {
    setState(() {
      _showContributors = true;
    });
  }

  void _setShowContributorsToFalse() {
    setState(() {
      _showContributors = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: Text(
                'Tickets',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: theme.primaryColorDark,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_circle_outline_rounded),
                  iconSize: 30,
                  color: theme.primaryColorDark,
                )
              ],
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _setShowContributorsToFalse,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyTicketCard(
                    description: 'Lorem impsum',
                    amountRaised: 800,
                    totalAmount: 1000,
                    contributorCardOnTap: _setShowContributorsToTrue,
                  ),
                ),
                SizedBox(
                  height: 13.0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      child: GridView.builder(
                        itemCount: 24,
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 15,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          return FriendTicketIcon(name: 'Jamie');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_showContributors)
            Center(
              child: MyTicketContributors(),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        color: theme.backgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) Navigator.of(context).pop();
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: theme.primaryColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Conversations',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: theme.primaryColorDark,
                ),
                icon: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Tickets',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_taxi_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Uber',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_rounded,
                  size: 30,
                  color: Colors.white,
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
