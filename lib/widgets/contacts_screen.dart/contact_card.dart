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

    final snapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    final newConversationDocument = await _conversationsCollection.add({
      'members': [_auth.currentUser!.uid, snapshot.docs[0].id],
      'unreadTexts': 0
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: newConversationDocument.id,
          friendName: widget.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: double.infinity,
        child: Card(
          color: Theme.of(context).backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: Theme.of(context).primaryColor,
              )),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: CircleAvatar(
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
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            this.widget.name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).primaryColorDark,
                            )),
                          ),
                          Text(
                            this.widget.number,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context).primaryColorDark,
                            )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                showLoading
                    ? CircularProgressIndicator(
                        color: Theme.of(context).primaryColorDark,
                      )
                    : status == ContactRegisteredStatus.REGISTERED
                        ? IconButton(
                            onPressed: () => startConversation(),
                            icon: Icon(Icons.message_rounded),
                          )
                        : TextButton(
                            onPressed: () {},
                            child: Text(
                              'Invite',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Theme.of(context).primaryColorDark,
                              )),
                            ),
                          ),
              ],
            ),
          ),
        ));
  }
}
