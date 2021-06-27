import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:raven/screens/group_ride_invite.dart';
import 'package:raven/screens/places_results.dart';
import 'package:raven/screens/uber_screen.dart';
import 'package:raven/widgets/common/end_drawer.dart';

class DirectionsScreen extends StatefulWidget {
  final originLat;
  final originLng;
  final destinationLat;
  final destinationLng;
  final polyline;
  final bounds;
  final destinationPlaceName;

  DirectionsScreen(
      {required this.originLat,
      required this.originLng,
      required this.destinationLat,
      required this.destinationLng,
      required this.polyline,
      required this.bounds,
      required this.destinationPlaceName});

  @override
  _DirectionsScreenState createState() => _DirectionsScreenState();
}

class _DirectionsScreenState extends State<DirectionsScreen> {
  Marker? _originMarker = null;
  Marker? _destinationMarker = null;

  late GoogleMapController _googleMapController;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  void _createOriginMarker() {
    setState(() {
      _originMarker = Marker(
          markerId: MarkerId('origin'),
          position: LatLng(widget.originLat, widget.originLng),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Origin'));
    });
  }

  void _createdestinationMarkerAndPolyline(lat, lng) {
    setState(() {
      _destinationMarker = Marker(
          markerId: MarkerId('destination'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              HSLColor.fromColor(Theme.of(context).accentColor).hue),
          infoWindow: InfoWindow(title: 'Destination'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: theme.primaryColor,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'Directions',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 25,
        color: theme.primaryColorDark,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        height: size.height - appBar.preferredSize.height,
        child: Stack(
          children: [
            Container(
              height: size.height - appBar.preferredSize.height,
              child: GoogleMap(
                zoomControlsEnabled: false,
                polylines: {
                  Polyline(
                    polylineId: PolylineId('destinationpolyline'),
                    color: theme.accentColor,
                    width: 5,
                    points: PolylinePoints()
                        .decodePolyline(widget.polyline)
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
                },
                onMapCreated: (controller) {
                  _googleMapController = controller;
                  _createOriginMarker();
                  _createdestinationMarkerAndPolyline(
                      widget.destinationLat, widget.destinationLng);
                  _googleMapController.animateCamera(
                      CameraUpdate.newLatLngBounds(widget.bounds, 110));
                },
                markers: {
                  if (_originMarker != null) _originMarker!,
                  if (_destinationMarker != null) _destinationMarker!,
                },
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(widget.originLat, widget.originLng),
                    zoom: 16),
              ),
            ),
            Positioned(
                bottom: size.height * 0.02,
                left: size.width * 0.05,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UberScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_rounded,
                            color: theme.backgroundColor,
                            size: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Solo Ride',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.backgroundColor)),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          size.width * 0.4,
                          size.height * 0.06,
                        ),
                        primary: theme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.1),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => GroupRideInviteScreen(
                              originLat: widget.originLat,
                              originLng: widget.originLng,
                              destinationLat: widget.destinationLat,
                              destinationLng: widget.destinationLng,
                              polyline: widget.polyline,
                              bounds: widget.bounds,
                              destinationPlaceName: widget.destinationPlaceName,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.group_rounded,
                            color: theme.backgroundColor,
                            size: 22,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Group Ride',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: theme.backgroundColor)),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          size.width * 0.4,
                          size.height * 0.06,
                        ),
                        primary: theme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
