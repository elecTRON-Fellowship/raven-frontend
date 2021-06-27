import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteFriendCard extends StatefulWidget {
  final String friendId;
  final Function inviteCallback;
  final originLat;
  final originLng;
  final destinationLat;
  final destinationLng;
  final polyline;
  final bounds;
  final destinationPlaceName;

  InviteFriendCard(
      {required this.friendId,
      required this.inviteCallback,
      required this.originLat,
      required this.originLng,
      required this.destinationLat,
      required this.destinationLng,
      required this.polyline,
      required this.bounds,
      required this.destinationPlaceName});

  @override
  _InviteFriendCardState createState() => _InviteFriendCardState();
}

class _InviteFriendCardState extends State<InviteFriendCard> {
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';
  String fetchedNumber = '';

  String ticketId = '';

  @override
  void initState() {
    super.initState();
    fetchFriendDetails();
  }

  void fetchFriendDetails() async {
    final snapshot = await _userCollection.doc(widget.friendId).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
      fetchedNumber = data['phoneNumber'];
    });
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
            fontSize: 16,
            color: Colors.white,
          )),
        ),
        radius: 24,
      ),
      title: Text(
        fetchedName,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColorDark,
        )),
      ),
      subtitle: Text(
        fetchedNumber,
        style: GoogleFonts.poppins(
            textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Theme.of(context).primaryColor,
        )),
      ),
      trailing: IconButton(
        onPressed: () {
          widget.inviteCallback(widget.friendId);
        },
        iconSize: 30,
        icon: Icon(Icons.add_circle_outline_rounded),
        color: Theme.of(context).accentColor,
      ),
    );
  }
}
