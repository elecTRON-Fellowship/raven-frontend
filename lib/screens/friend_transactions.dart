import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/friend_transactions_screen.dart/friend_ticket_card.dart';
import 'package:raven/widgets/friend_transactions_screen.dart/friend_transaction_card.dart';

class FriendTransactionsScreen extends StatefulWidget {
  final String friendId;

  FriendTransactionsScreen({required this.friendId});

  @override
  _FriendTransactionsScreenState createState() =>
      _FriendTransactionsScreenState();
}

class _FriendTransactionsScreenState extends State<FriendTransactionsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
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
              fontSize: 24,
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.28,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: _ticketsCollection
                  .where('userId', isEqualTo: widget.friendId)
                  .where('isActive', isEqualTo: true)
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
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: documents.length,
                    itemBuilder: (context, index) => FriendTicketCard(
                      ticketId: documents[index].id,
                      description: documents[index]['description'],
                      amountRaised: double.parse(
                          documents[index]['amountRaised'].toString()),
                      totalAmount: double.parse(
                          documents[index]['totalAmount'].toString()),
                    ),
                  );
                  // return ListWheelScrollView.useDelegate(
                  //   itemExtent: 100.0,
                  //   diameterRatio: 2.5,

                  //   magnification: 1.5,
                  //   // overAndUnderCenterOpacity: 1,
                  //   offAxisFraction: 0.1,
                  //   useMagnifier: true,
                  //   physics: PageScrollPhysics(),
                  //   // onSelectedItemChanged: (i) => print("Changed $i"),
                  //   // renderChildrenOutsideViewport: false,
                  //   // squeeze: 1.5,
                  //   childDelegate: ListWheelChildBuilderDelegate(
                  //     builder: (context, index) {
                  //       return MyTicketCard(
                  //         description: documents[index]['description'],
                  //         amountRaised: double.parse(documents[index]
                  //                 ['amountRaised']
                  //             .toString()),
                  //         totalAmount: double.parse(
                  //             documents[index]['totalAmount'].toString()),
                  //         contributorCardOnTap:
                  //             _setShowContributorsToTrue,
                  //       );
                  //     },
                  //   ),
                  // );
                } else {
                  return Container();
                }
              },
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _transactionsCollection
                      .where('userIds.${_auth.currentUser!.uid}',
                          isEqualTo: true)
                      .where('userIds.${widget.friendId}', isEqualTo: true)
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
                      return ListView.builder(
                        padding: EdgeInsets.all(15),
                        itemCount: documents.length,
                        itemBuilder: (context, index) => FriendTransactionCard(
                          status: documents[index]['sender'] ==
                                  _auth.currentUser!.uid
                              ? 'Sent'
                              : 'Received',
                          description: documents[index]['description'],
                          amount: double.parse(
                              documents[index]['amount'].toString()),
                          date: DateTime.parse(documents[index]['createdAt']
                              .toDate()
                              .toString()),
                        ),
                      );
                    } else {
                      return Container();
                    }
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
