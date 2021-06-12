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
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded),
                iconSize: 30,
                color: Color.fromRGBO(17, 128, 168, 1.0),
              ),
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
                  icon: Icon(Icons.credit_card_rounded),
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
              height: MediaQuery.of(context).size.height * 0.2,
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
                  itemCount: 12,
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1,
                    mainAxisExtent: 110,
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
        ],
      ),
    );
  }
}
