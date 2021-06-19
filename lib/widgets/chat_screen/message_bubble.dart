import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  MessageBubble(
      {required this.conversationId,
      required this.messageId,
      required this.key,
      required this.sender,
      required this.text,
      required this.time});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void markMessagesAsRead() async {
    if (this.widget.sender != _auth.currentUser!.uid) {
      await FirebaseFirestore.instance
          .collection('conversations/${widget.conversationId}/messages')
          .doc(widget.messageId)
          .update({'read': true});
    }
  }

  @override
  void initState() {
    super.initState();
    markMessagesAsRead();
  }

  @override
  Widget build(BuildContext context) {
    bool isSent = this.widget.sender == _auth.currentUser!.uid;
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
              DateFormat.Hm().format(this.widget.time),
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 14, color: Colors.grey[800])),
            ),
            Text(
              this.widget.text,
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
