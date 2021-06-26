import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raven/screens/timed_chat.dart';

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

  Marker? _originMarker = null;
  Marker? _destinationMarker = null;

  late GoogleMapController _googleMapController;
  TextEditingController searchController = new TextEditingController();

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
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  void _createOriginMarker() {
    setState(() {
      _originMarker = Marker(
          markerId: MarkerId('origin'),
          position: LatLng(
              double.parse(widget.originLat), double.parse(widget.originLng)),
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
    bool isSent = this.widget.sender == _auth.currentUser!.uid;

    return Container(
      width: 100,
      height: 100,
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
              double.parse(widget.destinationLat),
              double.parse(widget.destinationLng));
          _googleMapController.animateCamera(
              CameraUpdate.newLatLngBounds(widget.bounds as LatLngBounds, 110));
        },
        markers: {
          if (_originMarker != null) _originMarker!,
          if (_destinationMarker != null) _destinationMarker!,
        },
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(
            target: LatLng(
                double.parse(widget.originLat), double.parse(widget.originLng)),
            zoom: 16),
      ),
    );
  }
}
