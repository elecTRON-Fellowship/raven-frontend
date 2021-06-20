import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/chat.dart';
import 'package:raven/widgets/close_friends_screen/close_friend_action_button.dart';

enum ContactRegisteredStatus {
  REGISTERED,
  NOT_REGISTERED,
}

class CloseFriendCard extends StatefulWidget {
  final String name;
  final String number;

  CloseFriendCard({required this.name, required this.number});

  @override
  _CloseFriendCardState createState() => _CloseFriendCardState();
}

class _CloseFriendCardState extends State<CloseFriendCard> {
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
        radius: 24,
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
              ? CloseFriendActionButton(number: widget.number)
              : TextButton(
                  onPressed: () {},
                  child: Text(
                    'Invite',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Theme.of(context).primaryColor,
                    )),
                  ),
                ),
    );
  }
}
