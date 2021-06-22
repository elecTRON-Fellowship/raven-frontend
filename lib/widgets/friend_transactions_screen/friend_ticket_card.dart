import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/models/requestsSingleton.dart';

class FriendTicketCard extends StatefulWidget {
  final Function contributeCallback;
  final String friendId;
  final String friendName;
  final String ticketId;
  final String description;
  final double amountRaised;
  final double totalAmount;

  FriendTicketCard(
      {required this.contributeCallback,
      required this.friendId,
      required this.friendName,
      required this.ticketId,
      required this.description,
      required this.amountRaised,
      required this.totalAmount});

  @override
  _FriendTicketCardState createState() => _FriendTicketCardState();
}

class _FriendTicketCardState extends State<FriendTicketCard> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');
  late CollectionReference _contributorsCollection;

  TextEditingController ticketAmountController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _contributorsCollection = FirebaseFirestore.instance
        .collection('tickets/${widget.ticketId}/contributors');
    fetchWalletBalance();
  }

  double fetchedBalance = 0.0;
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

  void sendMoney(context) async {
    //update friend ticket
    final ticketSnapshot = await _ticketsCollection.doc(widget.ticketId).get();
    final data = ticketSnapshot.data() as Map;

    if (double.parse(data['amountRaised'].toString()) +
            double.parse(ticketAmountController.text.toString()) >=
        double.parse(data['totalAmount'].toString())) {
      await _ticketsCollection.doc(widget.ticketId).update({
        'amountRaised': double.parse(data['amountRaised'].toString()) +
            double.parse(ticketAmountController.text.toString()),
        'isActive': false
      });
    } else {
      await _ticketsCollection.doc(widget.ticketId).update({
        'amountRaised': double.parse(data['amountRaised'].toString()) +
            double.parse(ticketAmountController.text.toString())
      });
    }

    //update contributors on ticket
    await _contributorsCollection.add({
      'amount': double.parse(ticketAmountController.text.toString()),
      'userId': _auth.currentUser!.uid,
      'createdAt': DateTime.now()
    });

    //create transaction
    await _transactionsCollection.add({
      'amount': double.parse(ticketAmountController.text.toString()),
      'createdAt': DateTime.now(),
      'description': widget.description,
      'ticketId': widget.ticketId,
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

    ticketAmountController.clear();
    widget.contributeCallback();
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.26,
      width: size.width * 0.9,
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
                        value:
                            this.widget.amountRaised / this.widget.totalAmount,
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
                          color: theme.primaryColorDark),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                this.widget.description,
                textAlign: TextAlign.center,
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
              ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline_rounded),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Contribute',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.all(theme.accentColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {
                  if (!_isBalanceLoading)
                    createContributeDialog(context, theme, size);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  createContributeDialog(BuildContext context, final theme, final size) {
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
              child: Container(
                height: size.height * 0.65,
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
                        height: size.height * 0.02,
                      ),
                      Text(
                        widget.friendName,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColorDark,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        width: size.width * 0.48,
                        child: Text(
                          widget.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 18,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Container(
                        width: size.width * 0.5,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: ticketAmountController,
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
                      ),
                      SizedBox(
                        height: size.height * 0.04,
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
                        "Wallet Balance: $fetchedBalance",
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
                          var res =
                              await _requestsSingleton.addMoneyToWallet("5000");

                          if (res.statusCode == 200) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '₹5000 has been added to your wallet.',
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
          );
        });
  }

  void showAlertDialog(BuildContext context, final theme) => showDialog(
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
              "₹${double.parse(ticketAmountController.text).toStringAsFixed(2)} will be deducted from your wallet",
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
                      ticketAmountController.text, widget.friendId);

                  if (res.statusCode == 200) {
                    sendMoney(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '₹${ticketAmountController.text} has been sent to ${widget.friendName}.',
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
