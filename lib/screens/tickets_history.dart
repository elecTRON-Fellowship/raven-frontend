import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';
import 'package:uuid/uuid.dart';

class TicketsHistoryScreen extends StatefulWidget {
  const TicketsHistoryScreen({Key? key}) : super(key: key);

  @override
  _TicketsHistoryScreenState createState() => _TicketsHistoryScreenState();
}

class _TicketsHistoryScreenState extends State<TicketsHistoryScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 25,
        color: theme.primaryColorDark,
      ),
      centerTitle: true,
      title: Text(
        'Closed Tickets',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: appBar,
      body: Container(
        height: size.height,
        width: size.width,
        color: theme.primaryColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: _ticketsCollection
              .where('userId', isEqualTo: _auth.currentUser!.uid)
              .where('isActive', isEqualTo: false)
              .orderBy('createdAt', descending: true)
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
              return ListWheelScrollView.useDelegate(
                key: ValueKey(Uuid().v4()),
                itemExtent: size.height * 0.3,
                diameterRatio: 12,
                overAndUnderCenterOpacity: 1,
                // offAxisFraction: 0.5,
                // useMagnifier: true,
                // magnification: 1.5,
                physics: PageScrollPhysics(),
                // renderChildrenOutsideViewport: false,
                // squeeze: 1.5,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: documents.length,
                  builder: (context, index) {
                    return MyTicketCard(
                      ticketId: documents[index].id,
                      description: documents[index]['description'],
                      amountRaised: double.parse(
                          documents[index]['amountRaised'].toString()),
                      totalAmount: double.parse(
                          documents[index]['totalAmount'].toString()),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
