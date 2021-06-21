import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/screens/friend_transactions.dart';

class FriendTicketIcon extends StatefulWidget {
  final String friendId;

  FriendTicketIcon({required this.friendId});

  @override
  _FriendTicketIconState createState() => _FriendTicketIconState();
}

class _FriendTicketIconState extends State<FriendTicketIcon> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  @override
  void initState() {
    super.initState();
    fetchContributorName();
  }

  @override
  void dispose() {
    super.dispose();
    fetchedName = "";
  }

  fetchContributorName() async {
    final snapshot = await _userCollection.doc(widget.friendId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FriendTransactionsScreen(
                  friendId: widget.friendId,
                ),
              ),
            );
          },
          child: CircleAvatar(
            backgroundColor: theme.accentColor,
            child: Text(
              fetchedName.isNotEmpty
                  ? fetchedName
                      .trim()
                      .split(' ')
                      .map((l) => l[0])
                      .take(2)
                      .join()
                  : '',
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              )),
            ),
            radius: 30,
          ),
        ),
        SizedBox(
          height: 2.0,
        ),
        Text(
          fetchedName,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: theme.primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
