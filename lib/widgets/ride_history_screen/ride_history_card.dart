import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RideHistoryCard extends StatefulWidget {
  final String conversationId;
  final String sender;
  final DateTime time;
  final originLat;
  final originLng;
  final destinationLat;
  final destinationLng;
  final polyline;
  final bounds;
  final destinationPlaceName;
  final String ticketId;

  RideHistoryCard(
      {required this.conversationId,
      required this.sender,
      required this.time,
      required this.originLat,
      required this.originLng,
      required this.destinationLat,
      required this.destinationLng,
      required this.polyline,
      required this.bounds,
      required this.destinationPlaceName,
      required this.ticketId});

  @override
  _RideHistoryCardState createState() => _RideHistoryCardState();
}

class _RideHistoryCardState extends State<RideHistoryCard> {
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');

  double rideFare = 0.0;

  @override
  void initState() {
    super.initState();
    fetchRideFare();
  }

  void fetchRideFare() async {
    final ticketSnapshot = await _ticketsCollection.doc(widget.ticketId).get();
    final data = ticketSnapshot.data() as Map;

    if (!mounted) return;
    setState(() {
      rideFare = data['totalAmount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    double _mapWidth = size.width;
    double _mapHeight = size.height * 0.2;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.primaryColor)),
      width: double.infinity,
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(8),
        childrenPadding: EdgeInsets.all(8),
        title: Text(
          this.widget.destinationPlaceName,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: theme.primaryColorDark)),
        ),
        subtitle: Text(
          '${DateFormat.yMd().add_Hm().format(this.widget.time)}, ₹${rideFare.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 14, color: theme.primaryColor)),
        ),
        children: [
          Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?zoom=13&size=${_mapWidth.floor()}x${_mapHeight.floor()}&markers=color:red|${this.widget.destinationLat},${this.widget.destinationLng}&key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
