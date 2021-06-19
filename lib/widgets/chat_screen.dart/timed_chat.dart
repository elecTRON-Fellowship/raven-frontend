import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/timed_chat.dart';

class TimedChatInvite extends StatefulWidget {
  // final String timedChatStatus;
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;

  TimedChatInvite(
      {
      // required this.timedChatStatus,
      required this.conversationId,
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
    // timedChatStatus = widget.timedChatStatus;
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
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final data = (snapshot.data)!.data() as Map;

          final status = data['status'];

          if (status == 'PENDING') {
            return Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                isSent
                    ? Text('You sent an invitation',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor)))
                    : Text('You received an invitation',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor))),
                Container(
                  decoration: BoxDecoration(
                    color: isSent
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(144, 180, 206, 0.5),
                    borderRadius: isSent
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Up for a coffee break?',
                            style: GoogleFonts.poppins(
                                textStyle: isSent
                                    ? TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                    : TextStyle(
                                        fontSize: 17,
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
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        onPressed: () {
                                          acceptTimedChatInvitation();
                                        },
                                        icon: Icon(Icons.check_circle_rounded)),
                                    IconButton(
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        onPressed: () {
                                          declineTimedChatInvitation();
                                        },
                                        icon: Icon(Icons.cancel_rounded)),
                                  ],
                                )
                        ],
                      )),
                ),
              ],
            );
          } else if (status == 'DECLINED') {
            return Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                isSent
                    ? Text('Your invitation was declined',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor)))
                    : Text('You declined an invitation',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor))),
                Container(
                  decoration: BoxDecoration(
                    color: isSent
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(144, 180, 206, 0.5),
                    borderRadius: isSent
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Up for a coffee break?',
                            style: GoogleFonts.poppins(
                                textStyle: isSent
                                    ? TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                    : TextStyle(
                                        fontSize: 17,
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
                              : IconButton(
                                  color: Theme.of(context).primaryColorDark,
                                  onPressed: () {},
                                  icon: Icon(Icons.cancel_rounded))
                        ],
                      )),
                ),
              ],
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
            return Column(
              crossAxisAlignment:
                  isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                isSent
                    ? Text('Your invitation was accepted',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor)))
                    : Text('You accepted an invitation',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).accentColor))),
                Container(
                  decoration: BoxDecoration(
                    color: isSent
                        ? Theme.of(context).accentColor
                        : Color.fromRGBO(144, 180, 206, 0.5),
                    borderRadius: isSent
                        ? BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 13),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Up for a coffee break?',
                            style: GoogleFonts.poppins(
                                textStyle: isSent
                                    ? TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)
                                    : TextStyle(
                                        fontSize: 17,
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
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
