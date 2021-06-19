import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/tickets_screen/friend_ticket_icon.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_contributors.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');

  bool _showContributors = false;
  String _showContributorsTicketId = '';
  final _formKey = GlobalKey<FormState>();

  void _setShowContributorsToTrue(String ticketId) {
    setState(() {
      _showContributors = true;
      _showContributorsTicketId = ticketId;
    });
  }

  void _setShowContributorsToFalse() {
    setState(() {
      _showContributors = false;
      _showContributorsTicketId = '';
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
        automaticallyImplyLeading: false,
        title: Text(
          'Tickets',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showOverlay(theme, size);
            },
            icon: Icon(Icons.add_circle_outline_rounded),
            iconSize: 30,
            color: theme.primaryColorDark,
          )
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _setShowContributorsToFalse();
            },
            child: Column(
              children: [
                Container(
                  height: size.height * 0.28,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _ticketsCollection
                        .where('userId', isEqualTo: _auth.currentUser!.uid)
                        .where('isActive', isEqualTo: true)
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
                          itemBuilder: (context, index) => MyTicketCard(
                            ticketId: documents[index].id,
                            description: documents[index]['description'],
                            amountRaised: double.parse(
                                documents[index]['amountRaised'].toString()),
                            totalAmount: double.parse(
                                documents[index]['totalAmount'].toString()),
                            contributorCardOnTap: () =>
                                _setShowContributorsToTrue(documents[index].id),
                          ),
                        );
                        // return ListWheelScrollView.useDelegate(
                        //   itemExtent: 100.0,
                        //   diameterRatio: 2.5,

                        //   magnification: 1.5,
                        //   // overAndUnderCenterOpacity: 1,
                        //   offAxisFraction: 0.1,
                        //   useMagnifier: true,
                        //   physics: PageScrollPhysics(),
                        //   // onSelectedItemChanged: (i) => print("Changed $i"),
                        //   // renderChildrenOutsideViewport: false,
                        //   // squeeze: 1.5,
                        //   childDelegate: ListWheelChildBuilderDelegate(
                        //     builder: (context, index) {
                        //       return MyTicketCard(
                        //         description: documents[index]['description'],
                        //         amountRaised: double.parse(documents[index]
                        //                 ['amountRaised']
                        //             .toString()),
                        //         totalAmount: double.parse(
                        //             documents[index]['totalAmount'].toString()),
                        //         contributorCardOnTap:
                        //             _setShowContributorsToTrue,
                        //       );
                        //     },
                        //   ),
                        // );
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _ticketsCollection
                            .where('userId',
                                isNotEqualTo: _auth.currentUser!.uid)
                            .where('isActive', isEqualTo: true)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Center(child: Text('Something went wrong'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData) {
                            final documents = (snapshot.data)!.docs;
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
                                    friendId: documents[index]['userId']);
                              },
                            );
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
          ),
          if (_showContributors)
            Center(
              child: MyTicketContributors(
                ticketId: _showContributorsTicketId,
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        color: theme.backgroundColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BottomNavigationBar(
            currentIndex: 1,
            onTap: (index) {
              if (index == 0) Navigator.of(context).pop();
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: theme.primaryColor,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Conversations',
              ),
              BottomNavigationBarItem(
                activeIcon: Icon(
                  Icons.message_rounded,
                  size: 30,
                  color: theme.primaryColorDark,
                ),
                icon: Icon(
                  Icons.account_balance_wallet_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Tickets',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_taxi_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Uber',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                label: 'Settings',
              ),
            ],
          ),
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
              side: BorderSide(
                color: theme.primaryColor,
                width: 2,
              )),
          child: Container(
            width: size.width * 0.75,
            height: size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: theme.backgroundColor,
              border: Border.all(color: theme.primaryColor, width: 2),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                            color: theme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: theme.primaryColor,
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
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    width: size.width * 0.5,
                    child: TextFormField(
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
                            color: theme.primaryColor,
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
                            color: theme.primaryColorDark,
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
                        Navigator.of(context, rootNavigator: true).pop();
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
}
