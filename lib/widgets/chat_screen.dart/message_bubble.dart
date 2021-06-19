import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  MessageBubble(this.key, this.sender, this.text, this.time);

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool isSent = this.sender == _auth.currentUser!.uid;
    return Container(
      margin: isSent
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      decoration: BoxDecoration(
        color: isSent
            ? Theme.of(context).accentColor
            : Color.fromRGBO(144, 180, 206, 0.5),
        borderRadius: isSent
            ? BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.Hm().format(this.time),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: Colors.grey[800])),
            ),
            Text(
              this.text,
              style: isSent
                  ? GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 15, color: Colors.white))
                  : GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColorDark)),
            ),
          ],
        ),
      ),
    );
  }
}
