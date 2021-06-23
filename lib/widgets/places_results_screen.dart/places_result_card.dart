import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class PlacesResultCard extends StatefulWidget {
  final Map placeObject;
  final String origin;

  PlacesResultCard({required this.placeObject, required this.origin});

  @override
  _PlacesResultCardState createState() => _PlacesResultCardState();
}

class _PlacesResultCardState extends State<PlacesResultCard> {
  String distance = '';
  String duration = '';
  Image? image;

  void calculateDistance() async {
    final destination = widget.placeObject['place_id'];

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&origin=${widget.origin}&destination=place_id:$destination');

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (!mounted) return;
      setState(() {
        distance = body['routes'][0]['legs'][0]['distance']['text'];
        duration = body['routes'][0]['legs'][0]['duration']['text'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    calculateDistance();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    List photos = widget.placeObject['photos'];
    String photoRef = photos[0]['photo_reference'];
    double height = size.height * 0.15;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 1, color: theme.primaryColor),
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(10),
          childrenPadding: EdgeInsets.all(10),
          title: Text(
            this.widget.placeObject['name'],
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColorDark)),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.015,
              ),
              Text(
                this.widget.placeObject['vicinity'],
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 14, color: theme.primaryColor)),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  Text(
                    distance,
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 14, color: theme.primaryColor)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    duration,
                    style: GoogleFonts.poppins(
                        textStyle:
                            TextStyle(fontSize: 14, color: theme.primaryColor)),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                this.widget.placeObject['rating'].toString(),
                style: GoogleFonts.poppins(
                    textStyle:
                        TextStyle(fontSize: 14, color: theme.primaryColor)),
              ),
            ],
          ),
          children: [
            Container(
              height: size.height * 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&photoreference=$photoRef&maxheight=${height.floor()}",
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
