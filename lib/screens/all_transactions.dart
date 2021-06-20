import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/all_transactions_screen/transaction_card.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({Key? key}) : super(key: key);

  @override
  _AllTransactionsScreenState createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'Transactions',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: theme.primaryColorDark)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
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
          child: StreamBuilder(
            stream: _transactionsCollection
                .where('userIds', arrayContains: _auth.currentUser!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                final documents = (snapshot.data)!.docs;
                if (documents.isNotEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: documents.length,
                    itemBuilder: (context, index) => TransactionCard(
                      friendUserId: (documents[index]['userIds'][0]) ==
                              _auth.currentUser!.uid
                          ? (documents[index]['userIds'][1])
                          : (documents[index]['userIds'][0]),
                      amount:
                          double.parse(documents[index]['amount'].toString()),
                      date: DateTime.parse(
                          documents[index]['createdAt'].toDate().toString()),
                      description: documents[index]['description'],
                      status:
                          documents[index]['sender'] == _auth.currentUser!.uid
                              ? 'Sent'
                              : 'Received',
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      'No transactions to show.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
