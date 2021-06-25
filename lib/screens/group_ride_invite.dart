import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/group_ride_invite_screen/invite_friend_card.dart';
import 'package:uuid/uuid.dart';

class GroupRideInviteScreen extends StatefulWidget {
  final originLat;
  final originLng;
  final destinationLat;
  final destinationLng;
  final polyline;
  final bounds;
  final destinationPlaceName;

  GroupRideInviteScreen(
      {required this.originLat,
      required this.originLng,
      required this.destinationLat,
      required this.destinationLng,
      required this.polyline,
      required this.bounds,
      required this.destinationPlaceName});

  @override
  _GroupRideInviteScreenState createState() => _GroupRideInviteScreenState();
}

class _GroupRideInviteScreenState extends State<GroupRideInviteScreen> {
  List closeFriends = [];
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCloseFriends();
  }

  void fetchCloseFriends() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    CollectionReference _usersCollection =
        FirebaseFirestore.instance.collection('users');

    final snapshot = await _usersCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;

    setState(() {
      closeFriends = data['closeFriends'];
      showLoading = false;
    });
  }

  void dismissItemFromList(element) {
    setState(() {
      closeFriends.remove(element);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'Ride With',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.primaryColorDark)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/conversations', (r) => false);
            },
            icon: Icon(Icons.check_rounded),
            iconSize: 25,
            color: Theme.of(context).primaryColorDark,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: showLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColorDark,
                    ),
                  )
                : ListView.builder(
                    key: ValueKey(Uuid().v4()),
                    itemCount: closeFriends.length,
                    itemBuilder: (context, index) => InviteFriendCard(
                      friendId: closeFriends[index],
                      inviteCallback: dismissItemFromList,
                      originLat: widget.originLat,
                      originLng: widget.originLng,
                      destinationLat: widget.destinationLat,
                      destinationLng: widget.destinationLng,
                      polyline: widget.polyline,
                      bounds: widget.bounds,
                      destinationPlaceName: widget.destinationPlaceName,
                    ),
                  )),
      ),
    );
  }
}
