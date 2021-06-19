import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendTicketCard extends StatefulWidget {
  final String ticketId;
  final String description;
  final double amountRaised;
  final double totalAmount;

  FriendTicketCard(
      {required this.ticketId,
      required this.description,
      required this.amountRaised,
      required this.totalAmount});

  @override
  _FriendTicketCardState createState() => _FriendTicketCardState();
}

class _FriendTicketCardState extends State<FriendTicketCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.26,
      width: size.width * 0.95,
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
                        value: 0.6,
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
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                this.widget.description,
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
                  side: BorderSide(
                    color: theme.primaryColor,
                    width: 2,
                  )),
              child: Container(
                height: size.height * 0.62,
                width: size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                      "Mizanali",
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
                        "Need money to spend on Abu Dhabi GP and some more.",
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
                  ],
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
                side: BorderSide(
                  color: theme.primaryColor,
                  width: 2,
                )),
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
              "9999 will be deducted from your wallet",
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
