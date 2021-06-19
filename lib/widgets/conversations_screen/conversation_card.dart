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

  late CollectionReference _messagesCollection;

  String fetchedName = '';
  String fetchedLastText = '';
  String fetchedLastTextTime = '';

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
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Theme.of(context).primaryColor)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: Text(
            fetchedName.isNotEmpty
                ? fetchedName.trim().split(' ').map((l) => l[0]).take(2).join()
                : '',
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
            StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('time', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                }
                if (snapshot.hasData) {
                  final documents = (snapshot.data)!.docs;
                  final data = documents[0].data() as Map<String, dynamic>;
                  String lastTextTime = DateFormat.Hm()
                      .format(DateTime.parse(data['time'].toDate().toString()));
                  return Text(
                    lastTextTime,
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
            StreamBuilder<QuerySnapshot>(
              stream: _messagesCollection
                  .orderBy('time', descending: true)
                  .limit(1)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('');
                }
                if (snapshot.hasData) {
                  final documents = (snapshot.data)!.docs;
                  final data = documents[0].data() as Map<String, dynamic>;
                  String lastText = data['text'];
                  return Text(
                    lastText,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 14, color: Colors.grey)),
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
                                textStyle: TextStyle(
                                    fontSize: 14, color: Colors.white)),
                          ),
                          radius: 12,
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
      ),
    );
  }
}
