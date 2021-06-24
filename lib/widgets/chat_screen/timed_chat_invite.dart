import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/timed_chat.dart';

class TimedChatInvite extends StatefulWidget {
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  TimedChatInvite(
      {required this.conversationId,
      required this.messageId,
      required this.key,
      required this.sender,
      required this.text,
      required this.time});

  @override
  _TimedChatInviteState createState() => _TimedChatInviteState();
}

class _TimedChatInviteState extends State<TimedChatInvite> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late CollectionReference _messagesCollection;

  // late String timedChatStatus;

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
    markMessagesAsRead();
  }

  void acceptTimedChatInvitation() async {
    await _messagesCollection
        .doc(widget.messageId)
        .update({'status': 'ACCEPTED'});
  }

  void declineTimedChatInvitation() async {
    await _messagesCollection
        .doc(widget.messageId)
        .update({'status': 'DECLINED'});
  }

  void markMessagesAsRead() async {
    if (this.widget.sender != _auth.currentUser!.uid) {
      final data = _messagesCollection.doc(widget.messageId);
      await data.update({'read': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSent = this.widget.sender == _auth.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: _messagesCollection.doc(widget.messageId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasData) {
          final data = (snapshot.data)!.data() as Map;

          final status = data['status'];

          if (status == 'PENDING') {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment:
                    isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  isSent
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('You sent an invitation',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('You received an invitation',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: isSent
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.only(left: 10),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Up for a coffee break?',
                              style: GoogleFonts.poppins(
                                  textStyle: isSent
                                      ? TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)
                                      : TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                            ),
                            isSent
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.timer_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      IconButton(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          onPressed: () {
                                            acceptTimedChatInvitation();
                                          },
                                          icon: Icon(Icons
                                              .check_circle_outline_rounded)),
                                      IconButton(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          onPressed: () {
                                            declineTimedChatInvitation();
                                          },
                                          icon: Icon(Icons.cancel_outlined)),
                                    ],
                                  )
                          ],
                        )),
                  ),
                ],
              ),
            );
          } else if (status == 'DECLINED') {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment:
                    isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  isSent
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Your invitation was declined',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('You declined an invitation',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: isSent
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.only(left: 10),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Up for a coffee break?',
                              style: GoogleFonts.poppins(
                                  textStyle: isSent
                                      ? TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)
                                      : TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                            ),
                            isSent
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    color: Theme.of(context).primaryColorDark,
                                    onPressed: () {},
                                    icon: Icon(Icons.cancel_rounded))
                          ],
                        )),
                  ),
                ],
              ),
            );
          } else if (status == 'ACCEPTED') {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TimedChatScreen(
                    conversationId: widget.conversationId,
                    messageId: widget.messageId,
                  ),
                ),
              );
            });
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment:
                    isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  isSent
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Your invitation was accepted',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('You accepted an invitation',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: Theme.of(context).accentColor))),
                        ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: isSent
                        ? EdgeInsets.only(right: 10)
                        : EdgeInsets.only(left: 10),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Up for a coffee break?',
                              style: GoogleFonts.poppins(
                                  textStyle: isSent
                                      ? TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)
                                      : TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                            ),
                            isSent
                                ? IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                  )
                                : IconButton(
                                    color: Theme.of(context).primaryColorDark,
                                    onPressed: () {},
                                    icon: Icon(Icons.check_circle_rounded))
                          ],
                        )),
                  ),
                ],
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
