import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/friend_transactions_screen.dart/friend_ticket_card.dart';
import 'package:raven/widgets/friend_transactions_screen.dart/friend_transaction_card.dart';

class FriendTransactionsScreen extends StatelessWidget {
  const FriendTransactionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

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
              titleSpacing: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_rounded),
                iconSize: 30,
                color: theme.primaryColorDark,
              ),
              title: Text(
                'Transactions',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FriendTicketCard(
              friendName: args['friendName'] as String,
              description: 'Lorem ipsum',
              amountRaised: 100,
              totalAmount: 1000,
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
                child: ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return FriendTransactionCard(
                      status: 'Sent',
                      description: 'Lorem ipsum',
                      amount: 200,
                      date: '20/06/2021',
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
