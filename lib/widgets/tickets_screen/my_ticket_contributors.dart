import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributor_card.dart';

class MyTicketContributors extends StatelessWidget {
  final String ticketId;

  MyTicketContributors({required this.ticketId});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _contributorsCollection = FirebaseFirestore.instance
        .collection('tickets/${this.ticketId}/contributors');

    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: 320,
        width: 330,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: _contributorsCollection
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
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) => MyTicketContributorCard(
                  contributorId: documents[index]['userId'],
                  amountContributed:
                      double.parse(documents[index]['amount'].toString()),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  onTap: () {},
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
