import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:raven/screens/uber_screen.dart';
import 'package:raven/widgets/friend_transactions_screen/friend_ticket_card.dart';
import 'package:raven/widgets/tickets_screen/my_ticket_card.dart';

class RideDetailsScreen extends StatefulWidget {
  final String sender;
  final String ticketId;
  final String originLat;
  final String originLng;
  final String destinationLat;
  final String destinationLng;
  final String polyline;
  final String bounds;

  RideDetailsScreen({
    required this.ticketId,
    required this.sender,
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.polyline,
    required this.bounds,
  });

  @override
  _RideDetailsScreenState createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _ticketsCollection =
      FirebaseFirestore.instance.collection('tickets');
  CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  String fetchedName = '';

  Marker? _originMarker;
  Marker? _destinationMarker;
  late LatLngBounds myBounds;

  late GoogleMapController _googleMapController;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.sender != _auth.currentUser!.uid) fetchContactName();
    List<String> arr = widget.bounds.split(', ');

    String firstLat = arr[0].substring(20);
    String firstLng = arr[1].substring(0, arr[1].length - 1);

    String secondLat = arr[2].substring(7);
    String secondLng = arr[3].substring(0, arr[3].length - 2);

    setState(() {
      myBounds = LatLngBounds(
          southwest: LatLng(double.parse(firstLat), double.parse(firstLng)),
          northeast: LatLng(double.parse(secondLat), double.parse(secondLng)));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  fetchContactName() async {
    final snapshot = await _userCollection.doc(widget.sender).get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      fetchedName = "${data['firstName']} ${data['lastName']}";
    });
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

    final appBar = AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded),
        iconSize: 25,
        color: theme.primaryColorDark,
      ),
      centerTitle: true,
      title: Text(
        'Ride Details',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: size.height * 0.28,
            child: StreamBuilder<DocumentSnapshot>(
              stream: _ticketsCollection.doc(widget.ticketId).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  if (data.exists) {
                    if (data['isActive']) {
                      return widget.sender == _auth.currentUser!.uid
                          ? MyTicketCard(
                              ticketId: widget.ticketId,
                              description: data['description'],
                              amountRaised:
                                  double.parse(data['amountRaised'].toString()),
                              totalAmount:
                                  double.parse(data['totalAmount'].toString()),
                            )
                          : FriendTicketCard(
                              contributeCallback: () {},
                              friendId: widget.sender,
                              friendName: fetchedName,
                              ticketId: widget.ticketId,
                              description: data['description'],
                              amountRaised:
                                  double.parse(data['amountRaised'].toString()),
                              totalAmount:
                                  double.parse(data['totalAmount'].toString()),
                            );
                    } else {
                      return Container(
                        height: size.height * 0.26,
                        width: size.width * 0.9,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: theme.backgroundColor,
                          child: Center(
                            child: Text(
                              "The ticket for this ride has been closed.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return Container(
                      height: size.height * 0.26,
                      width: size.width * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Card(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        color: theme.backgroundColor,
                        child: Center(
                          child: Text(
                            "The ticket for this ride was deleted.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
          SizedBox(
            height: 13.0,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: theme.backgroundColor,
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
                        CameraUpdate.newLatLngBounds(myBounds, 110));
                  },
                  markers: {
                    if (_originMarker != null) _originMarker!,
                    if (_destinationMarker != null) _destinationMarker!,
                  },
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(widget.originLat),
                          double.parse(widget.originLng)),
                      zoom: 16),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UberScreen(),
              ),
            );
          },
          child: Icon(Icons.local_taxi_rounded)),
    );
  }
}
