import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/friend_transactions_screen/friend_ticket_card.dart';
import 'package:raven/widgets/friend_transactions_screen/friend_transaction_card.dart';

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

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    fetchContactName();
    fetchTransactions();
  }

  List transactionList = [];

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.friendId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  void refreshTransactions() {
    fetchTransactions();
  }

  void fetchTransactions() async {
    var transactionsSnapshot = await _transactionsCollection
        .where('userIdsMap.${_auth.currentUser!.uid}', isEqualTo: true)
        .where('userIdsMap.${widget.friendId}', isEqualTo: true)
        .get();

    var documents = transactionsSnapshot.docs.toList();

    print(documents[0].data());

    setState(() {
      documents.sort((item1, item2) {
        var one = item1.data() as Map;
        var two = item2.data() as Map;

        var m = DateTime.parse(one['createdAt'].toDate().toString());
        var n = DateTime.parse(two['createdAt'].toDate().toString());

        return n.compareTo(m);
      });
      transactionList = [...documents];
    });
  }

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
          iconSize: 25,
          color: theme.primaryColorDark,
        ),
        title: Text(
          fetchedName,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: theme.primaryColorDark,
            ),
          ),
        ),
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
                  .where('visibleTo', arrayContains: _auth.currentUser!.uid)
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
                    scrollDirection: Axis.horizontal,
                    itemCount: documents.length,
                    itemBuilder: (context, index) => FriendTicketCard(
                      contributeCallback: refreshTransactions,
                      friendId: widget.friendId,
                      friendName: fetchedName,
                      ticketId: documents[index].id,
                      description: documents[index]['description'],
                      amountRaised: double.parse(
                          documents[index]['amountRaised'].toString()),
                      totalAmount: double.parse(
                          documents[index]['totalAmount'].toString()),
                    ),
                  );
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
                child: ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) => FriendTransactionCard(
                    status: transactionList[index]['sender'] ==
                            _auth.currentUser!.uid
                        ? 'Sent'
                        : 'Received',
                    description: transactionList[index]['description'],
                    amount: double.parse(
                        transactionList[index]['amount'].toString()),
                    date: DateTime.parse(transactionList[index]['createdAt']
                        .toDate()
                        .toString()),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
