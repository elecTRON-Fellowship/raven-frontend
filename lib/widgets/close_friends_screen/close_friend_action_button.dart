import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum CloseFriendStatus {
  CLOSE_FRIEND,
  NOT_CLOSE_FRIEND,
}

class CloseFriendActionButton extends StatefulWidget {
  final String number;

  CloseFriendActionButton({required this.number});

  @override
  _CloseFriendActionButtonState createState() =>
      _CloseFriendActionButtonState();
}

class _CloseFriendActionButtonState extends State<CloseFriendActionButton> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  bool showLoading = true;

  CloseFriendStatus status = CloseFriendStatus.NOT_CLOSE_FRIEND;

  @override
  void initState() {
    super.initState();
    fetchCloseFriendStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchCloseFriendStatus() async {
    String numberToQuery = widget.number.replaceAll(new RegExp(r"\s+"), "");

    if (!numberToQuery.startsWith('+91')) {
      numberToQuery = '+91$numberToQuery';
    }

    final friendSnapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    final friendId = friendSnapshot.docs[0].id;

    final userSnapshot =
        await _userCollection.doc(_auth.currentUser!.uid).get();

    final data = userSnapshot.data() as Map;

    List closeFriends = data['closeFriends'];

    if (closeFriends.contains(friendId)) {
      setState(() {
        showLoading = false;
        status = CloseFriendStatus.CLOSE_FRIEND;
      });
    } else {
      setState(() {
        showLoading = false;
        status = CloseFriendStatus.NOT_CLOSE_FRIEND;
      });
    }
  }

  void addToCloseFriends() async {
    setState(() {
      status = CloseFriendStatus.CLOSE_FRIEND;
    });

    String numberToQuery = widget.number.replaceAll(new RegExp(r"\s+"), "");

    if (!numberToQuery.startsWith('+91')) {
      numberToQuery = '+91$numberToQuery';
    }

    final friendSnapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    final friendId = friendSnapshot.docs[0].id;

    final userSnapshot =
        await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = userSnapshot.data() as Map;

    List closeFriends = data['closeFriends'];

    closeFriends.add(friendId);

    await _userCollection
        .doc(_auth.currentUser!.uid)
        .update({"closeFriends": closeFriends});
  }

  void removeFromCloseFriends() async {
    setState(() {
      status = CloseFriendStatus.NOT_CLOSE_FRIEND;
    });

    String numberToQuery = widget.number.replaceAll(new RegExp(r"\s+"), "");

    if (!numberToQuery.startsWith('+91')) {
      numberToQuery = '+91$numberToQuery';
    }

    final friendSnapshot = await _userCollection
        .where('phoneNumber', isEqualTo: numberToQuery)
        .get();

    final idToRemove = friendSnapshot.docs[0].id;

    final userSnapshot =
        await _userCollection.doc(_auth.currentUser!.uid).get();
    final data = userSnapshot.data() as Map;

    List closeFriends = data['closeFriends'];

    closeFriends.remove(idToRemove);

    await _userCollection
        .doc(_auth.currentUser!.uid)
        .update({"closeFriends": closeFriends});
  }

  @override
  Widget build(BuildContext context) {
    return showLoading
        ? CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          )
        : status == CloseFriendStatus.CLOSE_FRIEND
            ? IconButton(
                onPressed: removeFromCloseFriends,
                icon: Icon(Icons.remove_circle_outline_rounded),
                iconSize: 30,
                color: Theme.of(context).accentColor,
              )
            : IconButton(
                onPressed: addToCloseFriends,
                iconSize: 30,
                icon: Icon(Icons.add_circle_outline_rounded),
                color: Theme.of(context).accentColor,
              );
  }
}
