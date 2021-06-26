import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/all_transactions_screen/transaction_card.dart';
import 'package:raven/widgets/common/end_drawer.dart';
import 'package:uuid/uuid.dart';

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
  int _selectedNavBarIndex = 3;

  void _onIndexChanged(index, ctx) {
    setState(() {
      _selectedNavBarIndex = index;
      print(_selectedNavBarIndex);
    });
    if (_selectedNavBarIndex == 0) {
      Navigator.of(context).pop();
    }
    if (_selectedNavBarIndex == 1) {
      Navigator.of(context).pushNamed('/tickets');
      setState(() {
        _selectedNavBarIndex = 0;
      });
    }
    if (_selectedNavBarIndex == 2) {
      Navigator.of(context).pushNamed('/map');
      setState(() {
        _selectedNavBarIndex = 0;
      });
    }
  }

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
                  fontSize: 20,
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
                    key: ValueKey(Uuid().v4()),
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
      endDrawer: EndDrawer(),
      bottomNavigationBar: Builder(
        builder: (ctx) => BottomNavigationBar(
          elevation: 2,
          currentIndex: _selectedNavBarIndex,
          onTap: (index) => _onIndexChanged(index, ctx),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: theme.primaryColor,
          selectedItemColor: theme.primaryColorDark,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
                size: 30,
              ),
              label: 'Conversations',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt_rounded,
                size: 30,
              ),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.place_rounded,
                size: 30,
              ),
              label: 'Uber',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 30,
              ),
              label: 'Transactions',
            ),
          ],
        ),
      ),
    );
  }
}
