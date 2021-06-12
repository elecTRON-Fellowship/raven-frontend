import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/friend_ticket_icon.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                    color: Color.fromRGBO(17, 128, 168, 1.0),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add_circle_outline_rounded),
                  iconSize: 30,
                  color: Color.fromRGBO(17, 128, 168, 1.0),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.26,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
            ),
            itemCount: 5,
            itemBuilder: (BuildContext context, int itemIndex, _) =>
                MyTicketCard(),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Color.fromRGBO(212, 230, 237, 1.0),
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
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return FriendTicketIcon();
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            color: Color.fromRGBO(212, 230, 237, 1.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BottomNavigationBar(
                currentIndex: 1,
                onTap: (index) {
                  if (index == 0) Navigator.of(context).pop();
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Theme.of(context).primaryColorDark,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.message_rounded,
                      size: 30,
                      color: Color.fromRGBO(194, 222, 232, 1.0),
                    ),
                    label: 'Conversations',
                  ),
                  BottomNavigationBarItem(
                    activeIcon: Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 30,
                      color: Colors.white,
                    ),
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
        ],
      ),
    );
  }
}
