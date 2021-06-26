import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupRideInvite extends StatefulWidget {
  final String conversationId;
  final String messageId;
  final Key key;
  final String sender;
  final String text;
  final DateTime time;
  final String originLat;
  final String originLng;
  final String destinationLat;
  final String destinationLng;
  final String polyline;
  final String bounds;
  final String destinationPlaceName;

  GroupRideInvite(
      {required this.conversationId,
      required this.messageId,
      required this.key,
      required this.sender,
      required this.text,
      required this.time,
      required this.originLat,
      required this.originLng,
      required this.destinationLat,
      required this.destinationLng,
      required this.polyline,
      required this.bounds,
      required this.destinationPlaceName});

  @override
  _GroupRideInviteState createState() => _GroupRideInviteState();
}

class _GroupRideInviteState extends State<GroupRideInvite> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  late CollectionReference _messagesCollection;
  late double _mapWidth;
  late double _mapHeight;

  @override
  void initState() {
    super.initState();
    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
    markMessagesAsRead();
  }

  void markMessagesAsRead() async {
    if (this.widget.sender != _auth.currentUser!.uid) {
      final data = _messagesCollection.doc(widget.messageId);
      await data.update({'read': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    bool isSent = this.widget.sender == _auth.currentUser!.uid;
    _mapWidth = size.width * 0.6;
    _mapHeight = size.height * 0.2;

    return Column(
      crossAxisAlignment:
          isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: isSent
                ? Theme.of(context).accentColor
                : Color.fromRGBO(144, 180, 206, 0.5),
          ),
          height: size.height * 0.37,
          width: size.width * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 0.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                  child: Image.network(
                    "https://maps.googleapis.com/maps/api/staticmap?center=${widget.destinationLat},${widget.destinationLng}&zoom=13&size=${_mapWidth.ceil()}x${_mapHeight.ceil()}&markers=color:red%7C%7C${widget.destinationLat},${widget.destinationLng}&key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                height: size.height * 0.15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Ride with me ",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isSent
                              ? theme.backgroundColor
                              : theme.primaryColorDark,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.5,
                      child: Text(
                        widget.destinationPlaceName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: isSent
                                ? theme.backgroundColor
                                : theme.primaryColorDark,
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: isSent
                          ? Text(
                              "Call a cab",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColorDark,
                                ),
                              ),
                            )
                          : Text(
                              "Directions",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: theme.accentColor,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
