import 'dart:math';

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
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _conversationsCollection =
      FirebaseFirestore.instance.collection('conversations');
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  List friendsInvited = [];

  @override
  void initState() {
    super.initState();
    fetchCloseFriends();
  }

  void fetchCloseFriends() async {
    final snapshot = await _usersCollection.doc(_auth.currentUser!.uid).get();
    final data = snapshot.data() as Map;

    setState(() {
      closeFriends = data['closeFriends'];
      showLoading = false;
    });
  }

  void dismissItemFromList(element) {
    setState(() {
      friendsInvited.add(element);
      closeFriends.remove(element);
    });
  }

  void createTicketAndSendGroupRideInvites() async {
    var createdTicket = await _ticketsCollection.add({
      'createdAt': DateTime.now(),
      'userId': _auth.currentUser!.uid,
      'isActive': true,
      'amountRaised': 0.00,
      'description': 'Cab ride to ${widget.destinationPlaceName}',
      'totalAmount':
          double.parse((Random().nextDouble() * 200 + 300).toStringAsFixed(2)),
      'visibleTo': friendsInvited
    });

    friendsInvited.forEach((friendId) async {
      bool _isConversationFound = false;

      var conversationsSnapshot = await _conversationsCollection
          .where('userIds.${_auth.currentUser!.uid}', isEqualTo: true)
          .where('userIds.$friendId', isEqualTo: true)
          .get();

      if (conversationsSnapshot.docs.length != 0) {
        _isConversationFound = true;
      }

      if (_isConversationFound) {
        CollectionReference _messagesCollection = FirebaseFirestore.instance
            .collection(
                'conversations/${conversationsSnapshot.docs[0].id}/messages');
        final currentTime = DateTime.now();

        await _messagesCollection.add({
          'time': currentTime,
          'sender': _auth.currentUser!.uid,
          'text': '/GROUP_RIDE_INVITE',
          'read': false,
          'originLat': widget.originLat.toString(),
          'originLng': widget.originLng.toString(),
          'destinationLat': widget.destinationLat.toString(),
          'destinationLng': widget.destinationLng.toString(),
          'polyline': widget.polyline.toString(),
          'bounds': widget.bounds.toString(),
          'destinationPlaceName': widget.destinationPlaceName,
          'ticketId': createdTicket.id
        });

        await _conversationsCollection
            .doc(conversationsSnapshot.docs[0].id)
            .update({'lastText': 'Group Ride Invite', 'lastTime': currentTime});
      } else {
        final currentTime = DateTime.now();

        final newConversationDocument = await _conversationsCollection.add({
          'members': [_auth.currentUser!.uid, friendId],
          'unreadTexts': 0,
          'userIds': {_auth.currentUser!.uid: true, friendId: true},
          'lastText': 'Group Ride Invite',
          'lastTime': currentTime
        });

        CollectionReference _messagesCollection = FirebaseFirestore.instance
            .collection('conversations/${newConversationDocument.id}/messages');

        await _messagesCollection.add({
          'time': currentTime,
          'sender': _auth.currentUser!.uid,
          'text': '/GROUP_RIDE_INVITE',
          'read': false,
          'originLat': widget.originLat.toString(),
          'originLng': widget.originLng.toString(),
          'destinationLat': widget.destinationLat.toString(),
          'destinationLng': widget.destinationLng.toString(),
          'polyline': widget.polyline.toString(),
          'bounds': widget.bounds.toString(),
          'destinationPlaceName': widget.destinationPlaceName,
          'ticketId': createdTicket.id
        });
      }
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
              createTicketAndSendGroupRideInvites();
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
