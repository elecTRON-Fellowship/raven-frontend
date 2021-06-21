import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/all_transactions.dart';
import 'package:raven/widgets/common/end_drawer.dart';
import 'package:raven/widgets/tickets_screen/friend_ticket_icon.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  TextEditingController ticketDescriptionController =
      new TextEditingController();
  TextEditingController ticketAmountController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void createTicket() async {
    final snapshot = await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;

    await _ticketsCollection.add({
      'createdAt': DateTime.now(),
      'userId': _auth.currentUser!.uid,
      'isActive': true,
      'amountRaised': 0.00,
      'description': ticketDescriptionController.text,
      'totalAmount': double.parse(ticketAmountController.text.toString()),
      'visibleTo': data['closeFriends']
    });

    ticketDescriptionController.clear();
    ticketAmountController.clear();
    Navigator.of(context).pop();
  }

  int _selectedNavBarIndex = 1;

  void _onIndexChanged(index, ctx) {
    setState(() {
      _selectedNavBarIndex = index;
      print(_selectedNavBarIndex);
    });
    if (_selectedNavBarIndex == 0) {
      Navigator.of(context).pop();
    }
    if (_selectedNavBarIndex == 3) {
      print("This is running");
      Scaffold.of(ctx).openEndDrawer();
      setState(() {
        _selectedNavBarIndex = 1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserHasCreatedWallet();
  }

  void checkIfUserHasCreatedWallet() async {
    final snapshot = await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;
    if (data['walletData'] == null) {
      Navigator.of(context).pushReplacementNamed('/create-wallet-user-details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Text(
        'Tickets',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AllTransactionsScreen(),
              ),
            );
          },
          icon: Icon(Icons.history_rounded),
          iconSize: 25,
          color: theme.primaryColorDark,
        ),
        IconButton(
          onPressed: () {
            showOverlay(theme, size);
          },
          icon: Icon(Icons.add_circle_outline_rounded),
          iconSize: 25,
          color: theme.primaryColorDark,
        )
      ],
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: size.height * 0.28,
            child: StreamBuilder<QuerySnapshot>(
              stream: _ticketsCollection
                  .where('userId', isEqualTo: _auth.currentUser!.uid)
                  .where('isActive', isEqualTo: true)
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
                      itemBuilder: (context, index) => Dismissible(
                        background: Container(
                          color: theme.primaryColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: theme.backgroundColor,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'This ticket will be deleted.',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: theme.backgroundColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_rounded,
                                    color: theme.backgroundColor,
                                    size: 22,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'This ticket will be deleted.',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: theme.backgroundColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        direction: DismissDirection.vertical,
                        key: ValueKey(documents[index].id),
                        onDismissed: (direction) {
                          showAlertDialog(context, theme, documents[index].id);
                        },
                        child: MyTicketCard(
                          ticketId: documents[index].id,
                          description: documents[index]['description'],
                          amountRaised: double.parse(
                              documents[index]['amountRaised'].toString()),
                          totalAmount: double.parse(
                              documents[index]['totalAmount'].toString()),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: size.height * 0.26,
                      width: size.width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap: () {
                          showOverlay(theme, size);
                        },
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: theme.backgroundColor,
                          child: Center(
                            child: Text(
                              'No active tickets.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
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
          SizedBox(
            height: 13.0,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _userCollection
                      .where('closeFriends',
                          arrayContains: _auth.currentUser!.uid)
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
                        return GridView.builder(
                          itemCount: documents.length,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 0,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            return FriendTicketIcon(
                              friendId: documents[index].id,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Tickets created by contacts who have you as a close friend will apear here.',
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
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
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
                Icons.account_balance_wallet_rounded,
                size: 30,
              ),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.local_taxi_rounded,
                size: 30,
              ),
              label: 'Uber',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_rounded,
                size: 30,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void showOverlay(final theme, final size) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
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
            width: size.width * 0.75,
            height: size.height * 0.57,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: theme.backgroundColor,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    "New Ticket",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    width: size.width * 0.6,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: ticketDescriptionController,
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
                    height: size.height * 0.04,
                  ),
                  Container(
                    width: size.width * 0.5,
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
                        } else if (double.parse(value.toString()) > 9999.00) {
                          return "Max amount allowed is 9999.00";
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        createTicket();
                      }
                    },
                    child: Text(
                      "Add Ticket",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                        size.width * 0.55,
                        size.height * 0.07,
                      ),
                      onPrimary: theme.backgroundColor,
                      primary: theme.accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, final theme, ticketId) => showDialog(
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
              "Are you sure?",
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
              "This ticket will be deleted.",
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
                  setState(() {});
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
                  await _ticketsCollection.doc(ticketId).delete();
                  Navigator.of(context, rootNavigator: true).pop();
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
