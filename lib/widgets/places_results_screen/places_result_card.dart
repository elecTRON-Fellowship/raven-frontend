import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:raven/screens/directions.dart';

class PlacesResultCard extends StatefulWidget {
  final Map placeObject;
  final originLatitude;
  final originLongitude;

  PlacesResultCard(
      {required this.placeObject,
      required this.originLatitude,
      required this.originLongitude});

  @override
  _PlacesResultCardState createState() => _PlacesResultCardState();
}

class _PlacesResultCardState extends State<PlacesResultCard> {
  String distanceAndDuration = '';
  List photos = [];
  String openHours = '';
  bool _showLoading = false;
  String polyline = '';
  LatLngBounds? bounds;

  void calculateDistance() async {
    final destination = widget.placeObject['place_id'];

    final origin = '${widget.originLatitude},${widget.originLongitude}';

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&origin=$origin&destination=place_id:$destination');

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (!mounted) return;
      setState(() {
        final distance = body['routes'][0]['legs'][0]['distance']['text'];
        final duration = body['routes'][0]['legs'][0]['duration']['text'];
        distanceAndDuration = '$distance, $duration';
        polyline = body['routes'][0]['overview_polyline']['points'];
        final northeast = body['routes'][0]['bounds']['northeast'];
        final southwest = body['routes'][0]['bounds']['southwest'];
        bounds = LatLngBounds(
            southwest: LatLng(southwest['lat'], southwest['lng']),
            northeast: LatLng(northeast['lat'], northeast['lng']));
      });
    }
  }

  void fetchPlaceDetails() async {
    final placeId = widget.placeObject['place_id'];

    print(placeId);

    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&place_id=$placeId');

    var res = await http.get(url);

    if (res.statusCode == 200) {
      var body = json.decode(res.body);
      if (body['result']['photos'] != null) {
        if (!mounted) return;
        setState(() {
          photos = body['result']['photos'];
        });
      }
      if (body['result']['opening_hours'] != null) {
        int dayOfTheWeek = DateTime.now().weekday;

        String open = (body['result']['opening_hours']['weekday_text']
                [dayOfTheWeek - 1])
            .split(": ")[1];

        String openingHours;
        if (open == 'Closed') {
          openingHours = 'Closed today';
        } else {
          openingHours = 'Open today: $open';
        }

        setState(() {
          openHours = openingHours;
        });
      } else {
        setState(() {
          openHours = 'Opening hours not found.';
        });
      }
      setState(() {
        _showLoading = false;
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
    double height = size.height * 0.18;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      // width: size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 1, color: theme.primaryColor),
        color: theme.backgroundColor,
      ),
      child: ExpansionTile(
        onExpansionChanged: (value) {
          if (value) {
            setState(() {
              _showLoading = true;
            });
            fetchPlaceDetails();
          }
        },
        tilePadding: EdgeInsets.all(15),
        childrenPadding: EdgeInsets.all(10),
        title: Row(
          children: [
            Image.network(
              this.widget.placeObject['icon'],
              fit: BoxFit.contain,
              width: 18,
            ),
            SizedBox(
              width: 4,
            ),
            Container(
              width: size.width * 0.7,
              child: Text(
                this.widget.placeObject['name'],
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColorDark)),
              ),
            ),
          ],
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
            Text(
              distanceAndDuration,
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 14, color: theme.primaryColor)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              children: [
                this.widget.placeObject['rating'] != null
                    ? Text(
                        this.widget.placeObject['rating'].toString(),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14, color: theme.primaryColor)),
                      )
                    : Text(
                        'No ratings',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14, color: theme.primaryColor)),
                      ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.stars_rounded,
                  color: theme.primaryColor,
                  size: 13,
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DirectionsScreen(
                        bounds: bounds,
                        destinationLat: widget.placeObject['geometry']
                            ['location']['lat'],
                        destinationLng: widget.placeObject['geometry']
                            ['location']['lng'],
                        originLat: widget.originLatitude,
                        originLng: widget.originLongitude,
                        polyline: polyline,
                        destinationPlaceName: this.widget.placeObject['name'],
                      ),
                    ),
                  );
                },
                child: Text(
                  'Directions',
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.backgroundColor)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    size.width * 0.5,
                    size.height * 0.06,
                  ),
                  primary: theme.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        children: [
          _showLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: theme.primaryColor,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      openHours,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14, color: theme.primaryColorDark)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: size.height * 0.18,
                      child: photos.length == 0
                          ? Center(
                              child: Text(
                                'No images found.',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Theme.of(context)
                                            .primaryColorDark)),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: photos.length,
                              itemBuilder: (context, index) {
                                var photoRef = photos[index]['photo_reference'];
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(
                                      "https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyA7JDmk8pXuhU5jm4l6YVhGxXk_fWpL2KY&photoreference=$photoRef&maxheight=${height.floor()}",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              }),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
