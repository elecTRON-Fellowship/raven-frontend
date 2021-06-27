import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/models/requests_singleton.dart';

final String logo = "assets/vectors/raven_logo.svg";

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  CollectionReference _transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  double fetchedBalance = 0.0;
  double monthAmt = 0.0;
  int openTickets = 0;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    fetchWalletBalance();
    fetchOpenTickets();
    fetchMonthlyAmount();
  }

  void fetchOpenTickets() async {
    final ticketSnapshot = await _ticketsCollection
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .where('isActive', isEqualTo: true)
        .get();

    final docs = ticketSnapshot.docs;

    setState(() {
      openTickets = docs.length;
    });
  }

  void fetchMonthlyAmount() async {
    final transactionSnapshot = await _transactionsCollection
        .where('sender', isEqualTo: _auth.currentUser!.uid)
        .get();

    final docs = transactionSnapshot.docs;

    double amount = 0.0;

    docs.forEach((element) {
      final dateTime = DateTime.parse(element['createdAt'].toDate().toString());

      if (dateTime.month == DateTime.now().month) {
        amount += element['amount'];
      }
    });

    setState(() {
      monthAmt = amount;
    });
  }

  void fetchWalletBalance() async {
    final _requestsSingleton = RequestsSingleton();
    var res = await _requestsSingleton.fetchWalletBalance();

    var data = json.decode(res.body);

    var balance = data['data']['data'][0]['balance'];

    if (res.statusCode == 200) {
      if (!mounted) return;

      setState(() {
        fetchedBalance = double.parse(balance.toString());
      });
    }
  }

  void fetchUserDetails() async {
    final userSnapshot =
        await _userCollection.doc(_auth.currentUser!.uid).get();

    final data = userSnapshot.data() as Map;

    setState(() {
      firstName = data['firstName'];
      lastName = data['lastName'];
      phoneNumber = data['phoneNumber'];
    });
  }

  Widget headerLogo(BuildContext context, var theme, var size) {
    return Container(
      height: size.height * 0.20,
      width: size.width * 0.35,
      color: theme.primaryColor,
      child: SvgPicture.asset(
        logo,
        color: theme.primaryColorDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final appBar = AppBar(
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
        'Account',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: appBar,
      body: Container(
          height: size.height - appBar.preferredSize.height,
          width: size.width,
          color: theme.primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  headerLogo(context, theme, size),
                  Text(
                    "Raven",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 22,
                        color: theme.primaryColorDark,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                    color: theme.backgroundColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name: $firstName',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        'Last Name: $lastName',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        'Phone Number: $phoneNumber',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        'Wallet Balance: ₹${fetchedBalance.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        'Money spent this month: ₹${monthAmt.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.025,
                      ),
                      Text(
                        'Open tickets: $openTickets',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
