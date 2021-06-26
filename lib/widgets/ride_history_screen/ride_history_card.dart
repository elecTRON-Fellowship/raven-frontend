import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class RideHistoryCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    double _mapWidth = size.width;
    double _mapHeight = size.height * 0.2;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: theme.primaryColorDark)),
      width: double.infinity,
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(8),
        childrenPadding: EdgeInsets.all(8),
        title: Text(
          this.destinationPlaceName,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: theme.primaryColorDark)),
        ),
        subtitle: Text(
          DateFormat.yMd().add_Hm().format(this.time),
          style: GoogleFonts.poppins(
              textStyle:
                  TextStyle(fontSize: 16, color: theme.primaryColorDark)),
        ),
        children: [
          Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?size=${_mapWidth.floor()}x${_mapHeight.floor()}&markers=color:red|${this.originLat},${this.originLng}&markers=color:blue|${this.destinationLat},${this.destinationLng}&key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY",
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
