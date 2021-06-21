import 'dart:ui';

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

  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        actions: [
          IconButton(
            onPressed: () {
              _createSendDialog(context, theme, size);
            },
            icon: Icon(Icons.add_circle_outline_rounded),
            iconSize: 25,
            color: theme.primaryColorDark,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: size.height * 0.28,
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
                  if (documents.isNotEmpty) {
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
                  } else
                    return Container(
                      height: size.height * 0.26,
                      width: size.width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: theme.backgroundColor,
                        child: Center(
                          child: Text(
                            "$fetchedName doesn't have any active tickets.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  ;
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

  _createSendDialog(BuildContext context, final theme, final size) {
    return showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Dialog(
              backgroundColor: theme.backgroundColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  height: size.height * 0.7,
                  width: size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Sending Money to",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text(
                        fetchedName,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Container(
                        width: size.width * 0.6,
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          controller: _descriptionController,
                          maxLines: 3,
                          minLines: 3,
                          maxLength: 60,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.primaryColorDark,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: theme.primaryColorDark,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: theme.primaryColorDark,
                                width: 2,
                              ),
                            ),
                            hintText: "Need money for.....",
                            hintStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Required";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        width: size.width * 0.5,
                        child: TextFormField(
                          controller: _amountController,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.primaryColorDark,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10.0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: theme.primaryColorDark,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(
                                color: theme.primaryColorDark,
                                width: 2,
                              ),
                            ),
                            hintText: "Amount",
                            hintStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (double.tryParse(value.toString()) == null) {
                              return "Enter a valid amount";
                            } else if (double.parse(value.toString()) <= 0) {
                              return "Amount can't be 0";
                            } else if (double.parse(value.toString()) >
                                9999.00) {
                              return "Max amount allowed is 9999.00";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context, rootNavigator: true).pop();
                            showAlertDialog(context, theme);
                          }
                        },
                        child: Text(
                          "Send Money",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                            size.width * 0.55,
                            size.height * 0.065,
                          ),
                          onPrimary: theme.backgroundColor,
                          primary: theme.accentColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        "Wallet Balance: 100000",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Add money to wallet",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context, final theme) => showDialog(
        context: context,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 5,
            sigmaY: 5,
          ),
          child: AlertDialog(
            backgroundColor: theme.backgroundColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(
              "Making payment",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColorDark,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            content: Text(
              "₹${double.parse(_amountController.text).toStringAsFixed(2)} will be deducted from your wallet",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: theme.primaryColor,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  "No",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.accentColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //sendMoney(context);
                },
                child: Text(
                  "Yes",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
