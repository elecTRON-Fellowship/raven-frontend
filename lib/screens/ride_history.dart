import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raven/widgets/ride_history_screen/ride_history_card.dart';
import 'package:uuid/uuid.dart';

class RideHistoryScreen extends StatefulWidget {
  final String conversationId;
  final String friendName;

  RideHistoryScreen({required this.conversationId, required this.friendName});

  @override
  _RideHistoryScreenState createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  late CollectionReference _messagesCollection;

  @override
  void initState() {
    super.initState();

    _messagesCollection = FirebaseFirestore.instance
        .collection('conversations/${widget.conversationId}/messages');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.primaryColor,
        centerTitle: true,
        title: Text(
          'Group Rides History',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.primaryColorDark)),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25,
          color: theme.primaryColorDark,
        ),
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
          child: StreamBuilder(
            stream: _messagesCollection
                .where('text', isEqualTo: '/GROUP_RIDE_INVITE')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }
              if (snapshot.hasData) {
                final documents = (snapshot.data)!.docs;
                if (documents.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.all(8),
                      key: ValueKey(Uuid().v4()),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        return RideHistoryCard(
                          conversationId: widget.conversationId,
                          sender: documents[index]['sender'],
                          time: DateTime.parse(
                              documents[index]['time'].toDate().toString()),
                          originLat: documents[index]['originLat'],
                          originLng: documents[index]['originLng'],
                          destinationLat: documents[index]['destinationLat'],
                          destinationLng: documents[index]['destinationLng'],
                          polyline: documents[index]['polyline'],
                          bounds: documents[index]['bounds'],
                          destinationPlaceName: documents[index]
                              ['destinationPlaceName'],
                          ticketId: documents[index]['ticketId'],
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      'Rides you share with ${widget.friendName} will show up here.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor)),
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
