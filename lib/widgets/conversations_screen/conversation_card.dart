import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:raven/screens/chat.dart';

class ConversationCard extends StatefulWidget {
  final String friendUserId;

  final int unreadTexts;

  final String conversationId;

  ConversationCard(
      {required this.friendUserId,
      required this.unreadTexts,
      required this.conversationId});

  @override
  _ConversationCardState createState() => _ConversationCardState();
}

class _ConversationCardState extends State<ConversationCard> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');

  late CollectionReference _messagesCollection;

  String fetchedName = '';
  String fetchedLastText = '';
  String fetchedlastTime = '';

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
    fetchContactName();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.friendUserId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    if (!mounted) return;

    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  void selectConversation(BuildContext context, String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
            conversationId: widget.conversationId,
            friendId: widget.friendUserId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        child: Text(
          fetchedName.isNotEmpty
              ? fetchedName.trim().split(' ').map((l) => l[0]).take(2).join()
              : '',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          )),
        ),
        radius: 24,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this.fetchedName,
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColorDark)),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream:
                _conversationsCollection.doc(widget.conversationId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('');
              }
              if (snapshot.hasData) {
                // final documents = (snapshot.data)!.docs;
                final data = snapshot.data!;
                String lastTime = data['lastTime'] == null
                    ? ''
                    : DateFormat.Hm().format(
                        DateTime.parse(data['lastTime'].toDate().toString()));
                return Text(
                  lastTime,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColorDark)),
                );
              } else {
                return Text('');
              }
            },
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream:
                _conversationsCollection.doc(widget.conversationId).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('');
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                String lastText = data['lastText'];
                if (lastText == 'Group Ride Invite') {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      lastText,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                } else if (lastText == 'Coffee Break') {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Text(
                      lastText,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    lastText,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                );
              } else {
                return Text('');
              }
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _messagesCollection
                .where('sender', isNotEqualTo: _auth.currentUser!.uid)
                .where('read', isEqualTo: false)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('');
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                final unreadMessages = data.docs.length;

                return unreadMessages == 0
                    ? Text('')
                    : CircleAvatar(
                        child: Text(
                          unreadMessages.toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                        ),
                        radius: 10,
                        backgroundColor: Theme.of(context).accentColor,
                      );
              } else {
                return Text('');
              }
            },
          ),
        ],
      ),
      onTap: () => selectConversation(context, this.fetchedName),
    );
  }
}
