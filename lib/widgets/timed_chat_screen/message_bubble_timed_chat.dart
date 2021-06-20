import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubbleTimedChat extends StatefulWidget {
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  MessageBubbleTimedChat(
      {required this.conversationId,
      required this.messageId,
      required this.key,
      required this.sender,
      required this.text,
      required this.time});

  @override
  _MessageBubbleTimedChatState createState() => _MessageBubbleTimedChatState();
}

class _MessageBubbleTimedChatState extends State<MessageBubbleTimedChat> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool isSent = this.widget.sender == _auth.currentUser!.uid;
    return Container(
      margin: isSent
          ? EdgeInsets.only(top: 4.0, bottom: 4.0, left: 80.0, right: 10.0)
          : EdgeInsets.only(top: 4.0, bottom: 4.0, right: 80.0, left: 10.0),
      decoration: BoxDecoration(
        color: isSent
            ? Theme.of(context).accentColor
            : Color.fromRGBO(144, 180, 206, 0.5),
        borderRadius: isSent
            ? BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              )
            : BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, top: 4.0, bottom: 4.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.Hm().format(this.widget.time),
              style: isSent
                  ? GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, color: Colors.grey[800]))
                  : GoogleFonts.poppins(
                      textStyle:
                          TextStyle(fontSize: 12, color: Colors.grey[800]),
                    ),
            ),
            Text(
              this.widget.text,
              style: isSent
                  ? GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, color: Colors.white))
                  : GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColorDark)),
            ),
          ],
        ),
      ),
    );
  }
}
