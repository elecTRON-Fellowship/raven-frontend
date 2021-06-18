import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/chat.dart';

enum ContactRegisteredStatus {
  REGISTERED,
  NOT_REGISTERED,
}

class ContactCard extends StatefulWidget {
  final String name;
  final String number;

  ContactCard({required this.name, required this.number});

  @override
  _ContactCardState createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference _conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');

  CollectionReference _connectionsCollection =
      FirebaseFirestore.instance.collection('connections');

  bool showLoading = true;

  ContactRegisteredStatus status = ContactRegisteredStatus.NOT_REGISTERED;

  @override
  void initState() {
    super.initState();
    fetchRegisteredStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchRegisteredStatus() async {
    String numberToQuery = widget.number.replaceAll(new RegExp(r"\s+"), "");

    if (!numberToQuery.startsWith('+91')) {
      numberToQuery = '+91$numberToQuery';
    }

    final snapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    if (snapshot.size > 0) {
      setState(() {
        showLoading = false;
        status = ContactRegisteredStatus.REGISTERED;
      });
    } else {
      setState(() {
        showLoading = false;
        status = ContactRegisteredStatus.NOT_REGISTERED;
      });
    }
  }

  void startConversation() async {
    String numberToQuery = widget.number.replaceAll(new RegExp(r"\s+"), "");

    if (!numberToQuery.startsWith('+91')) {
      numberToQuery = '+91$numberToQuery';
    }

    final userSnapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    bool _isConnectionFound = false;

    var connectionSnapshot = await _connectionsCollection
        .where('member0', isEqualTo: _auth.currentUser!.uid)
        .where('member1', isEqualTo: userSnapshot.docs[0].id)
        .get();

    if (connectionSnapshot.docs.length != 0) {
      _isConnectionFound = true;
    } else {
      connectionSnapshot = await _connectionsCollection
          .where('member0', isEqualTo: userSnapshot.docs[0].id)
          .where('member1', isEqualTo: _auth.currentUser!.uid)
          .get();

      if (connectionSnapshot.docs.length != 0) {
        _isConnectionFound = true;
      }
    }

    if (_isConnectionFound) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: connectionSnapshot.docs[0]['conversationId'],
            friendId: userSnapshot.docs[0].id,
          ),
        ),
      );
    } else {
      final newConversationDocument = await _conversationsCollection.add({
        'members': [_auth.currentUser!.uid, userSnapshot.docs[0].id],
        'unreadTexts': 0
      });

      final newConnectionDocument = await _connectionsCollection.add({
        'conversationId': newConversationDocument.id,
        'member0': _auth.currentUser!.uid,
        'member1': userSnapshot.docs[0].id
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: newConversationDocument.id,
            friendId: userSnapshot.docs[0].id,
          ),
        ),
      );
    }
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
              this.widget.name.isNotEmpty
                  ? this
                      .widget
                      .name
                      .trim()
                      .split(' ')
                      .map((l) => l[0])
                      .take(2)
                      .join()
                  : '',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              )),
            ),
          ),
          title: Text(
            this.widget.name,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).primaryColorDark,
            )),
          ),
          subtitle: Text(
            this.widget.number,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Theme.of(context).primaryColor,
            )),
          ),
          trailing: showLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )
              : status == ContactRegisteredStatus.REGISTERED
                  ? IconButton(
                      onPressed: () => startConversation(),
                      icon: Icon(Icons.message_rounded),
                      color: Theme.of(context).primaryColor,
                    )
                  : TextButton(
                      onPressed: () {},
                      child: Text(
                        'Invite',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                        )),
                      ),
                    ),
        ));
  }
}
