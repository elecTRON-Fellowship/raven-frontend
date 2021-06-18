import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributor_card.dart';

class MyTicketCard extends StatefulWidget {
  final Function contributorCardOnTap;
  final String description;
  final double amountRaised;
  final double totalAmount;
  final String ticketId;

  MyTicketCard({
    required this.contributorCardOnTap,
    required this.amountRaised,
    required this.description,
    required this.totalAmount,
    required this.ticketId,
  });

  @override
  _MyTicketCardState createState() => _MyTicketCardState();
}

class _MyTicketCardState extends State<MyTicketCard> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _contributorsCollection = FirebaseFirestore.instance
        .collection('tickets/${this.widget.ticketId}/contributors');

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.26,
      width: size.width * 0.95,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 3.0,
        color: theme.backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: LinearProgressIndicator(
                        backgroundColor: theme.primaryColor,
                        color: theme.primaryColorDark,
                        value: 0.6,
                        minHeight: 20,
                      ),
                    ),
                  ),
                  Text(
                    '₹${this.widget.amountRaised.toStringAsFixed(2)}/₹${this.widget.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                this.widget.description,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _contributorsCollection
                    .orderBy('createdAt', descending: true)
                    .limit(1)
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
                    final data = documents[0].data() as Map<String, dynamic>;

                    return MyTicketContributorCard(
                        contributorId: data['userId'],
                        amountContributed:
                            double.parse(data['amount'].toString()),
                        backgroundColor: Theme.of(context).backgroundColor,
                        onTap: this.widget.contributorCardOnTap);
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
