import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/models/requestsSingleton.dart';
import 'package:raven/screens/web_view.dart';
import 'package:raven/widgets/friend_transactions_screen/friend_ticket_card.dart';
import 'package:raven/widgets/friend_transactions_screen/friend_transaction_card.dart';
import 'package:uuid/uuid.dart';

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
    checkIfUserHasCreatedWallet();
    fetchContactName();
    fetchTransactions();
    fetchWalletBalance();
  }

  void checkIfUserHasCreatedWallet() async {
    final snapshot = await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;
    if (data['walletID'] == null) {
      Navigator.of(context).pushReplacementNamed('/create-wallet-user-details');
    }
  }

  void sendMoney(context) async {
    //create transaction
    await _transactionsCollection.add({
      'amount': double.parse(_amountController.text.toString()),
      'createdAt': DateTime.now(),
      'description': _descriptionController.text,
      'ticketId': null,
      'sender': _auth.currentUser!.uid,
      'userIds': [
        _auth.currentUser!.uid,
        widget.friendId,
      ],
      'userIdsMap': {
        _auth.currentUser!.uid: true,
        widget.friendId: true,
      }
    });

    _amountController.clear();
    _descriptionController.clear();
    refreshTransactions();
    Navigator.of(context, rootNavigator: true).pop();
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

  double fetchedBalance = 0;
  bool _isBalanceLoading = false;

  void fetchWalletBalance() async {
    _isBalanceLoading = true;

    final _requestsSingleton = RequestsSingleton();
    var res = await _requestsSingleton.fetchWalletBalance();

    var data = json.decode(res.body);

    var balance = data['data']['data'][0]['balance'];

    if (res.statusCode == 200) {
      if (!mounted) return;

      setState(() {
        fetchedBalance = double.parse(balance.toString());
        _isBalanceLoading = false;
      });
    }
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
              if (!_isBalanceLoading) {
                _createSendDialog(context, theme, size);
              }
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
                      key: ValueKey(Uuid().v4()),
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
                            "${fetchedName.split(' ').first} doesn't have any active tickets.",
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
                child: transactionList.isNotEmpty
                    ? ListView.builder(
                        key: ValueKey(Uuid().v4()),
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
                          date: DateTime.parse(transactionList[index]
                                  ['createdAt']
                              .toDate()
                              .toString()),
                        ),
                      )
                    : Center(
                        child: Text(
                          'No transactions to show.',
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
                  height: size.height * 0.58,
                  width: size.width * 0.8,
                  child: SingleChildScrollView(
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
                              hintText: "Send money for.....",
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
                          "Wallet Balance: ₹${fetchedBalance.toStringAsFixed(2)}",
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
                          onPressed: () async {
                            final _requestsSingleton = RequestsSingleton();
                            var res = await _requestsSingleton
                                .addMoneyToWallet("800");

                            print(res.body);

                            if (res.statusCode == 200) {
                              final data = json.decode(res.body);
                              Navigator.of(context).pop();
                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WebViewScreen(data["data"])));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '₹800 has been added to your wallet.',
                                    style: TextStyle(
                                        color: theme.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  backgroundColor: theme.primaryColor,
                                ),
                              );
                              fetchWalletBalance();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Something went wrong.',
                                    style: TextStyle(
                                        color: theme.primaryColorDark,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  backgroundColor: theme.primaryColor,
                                ),
                              );
                            }
                          },
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
                onPressed: () async {
                  final _requestsSingleton = RequestsSingleton();
                  var res = await _requestsSingleton.transferFunds(
                      _amountController.text, widget.friendId);

                  if (res.statusCode == 200) {
                    sendMoney(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '₹${_amountController.text} has been sent to $fetchedName.',
                          style: TextStyle(
                              color: theme.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                    fetchWalletBalance();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Something went wrong.',
                          style: TextStyle(
                              color: theme.primaryColorDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        backgroundColor: theme.primaryColor,
                      ),
                    );
                  }
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
