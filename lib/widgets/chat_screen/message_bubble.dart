import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  final bool isRead;
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  MessageBubble(
      {required this.isRead,
      required this.conversationId,
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
    return Row(
      mainAxisAlignment:
          isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
              padding: EdgeInsets.all(8.0),
              margin: isSent
                  ? EdgeInsets.only(
                      right: 4.0,
                      top: 4.0,
                      bottom: 4.0,
                      left: MediaQuery.of(context).size.width * 0.1,
                    )
                  : EdgeInsets.only(
                      left: 4.0,
                      top: 4.0,
                      bottom: 4.0,
                      right: MediaQuery.of(context).size.width * 0.1,
                    ),
              decoration: BoxDecoration(
                color: isSent
                    ? Theme.of(context).accentColor
                    : Color.fromRGBO(144, 180, 206, 0.5),
                borderRadius: isSent
                    ? BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topRight: Radius.circular(5),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(5),
                      ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                      child: Container(
                    child: Text(
                      this.widget.text,
                      style: isSent
                          ? GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 14, color: Colors.white))
                          : GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColorDark)),
                    ),
                  )),
                  SizedBox(
                    width: 8.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Text(
                      DateFormat.Hm().format(this.widget.time),
                      style: isSent
                          ? GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[800]))
                          : GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12, color: Colors.grey[800]),
                            ),
                    ),
                  ),
                  if (isSent)
                    SizedBox(
                      width: 8.0,
                    ),
                  if (isSent)
                    Padding(
                      padding: EdgeInsets.only(top: 6.0),
                      child: widget.isRead
                          ? Icon(
                              Icons.done_all_rounded,
                              size: 16,
                              color: Colors.grey[800],
                            )
                          : Icon(
                              Icons.done_rounded,
                              size: 16,
                              color: Colors.grey[800],
                            ),
                    ),
                ],
              )),
        )
      ],
    );
  }
}
