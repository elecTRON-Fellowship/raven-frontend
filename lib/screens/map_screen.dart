import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:raven/screens/places_results.dart';
import 'package:raven/widgets/common/end_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Marker? _originMarker = null;
  String _polyline = '';
  late GoogleMapController _googleMapController;
  TextEditingController searchController = new TextEditingController();
  int _selectedNavBarIndex = 2;
  Location location = new Location();

  late bool _serviceEnabled;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  late LocationData _locationData;
  bool _hasData = false;

  void _onIndexChanged(index, ctx) {
    setState(() {
      _selectedNavBarIndex = index;
      print(_selectedNavBarIndex);
    });
    if (_selectedNavBarIndex == 0) {
      Navigator.of(context).pop();
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
    if (_selectedNavBarIndex == 1) {
      Navigator.of(context).pushReplacementNamed('/tickets');
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
    if (_selectedNavBarIndex == 3) {
      Navigator.of(context).pushReplacementNamed('/all_transactions');
      setState(() {
        _selectedNavBarIndex = 2;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _googleMapController.dispose();
  }

  void _getPosition() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    if (!mounted) return;
    setState(() {
      _hasData = true;
    });
  }

  void _createOriginMarker() {
    if (!mounted) return;

    setState(() {
      _originMarker = Marker(
          markerId: MarkerId('origin'),
          position: LatLng(_locationData.latitude!, _locationData.longitude!),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Current Location'));
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
      title: Text(
        'Places',
        style: GoogleFonts.poppins(
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: theme.primaryColorDark,
          ),
        ),
      ),
      actions: [
        Builder(
          builder: (ctx) => IconButton(
            onPressed: () {
              Scaffold.of(ctx).openEndDrawer();
            },
            icon: Icon(Icons.menu_rounded),
            iconSize: 25,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: _hasData
          ? Container(
              height: size.height - appBar.preferredSize.height,
              child: Stack(
                children: [
                  Container(
                      height: size.height - appBar.preferredSize.height,
                      child: GoogleMap(
                        polylines: {
                          if (_polyline != '')
                            Polyline(
                              polylineId: PolylineId('destinationpolyline'),
                              color: theme.accentColor,
                              width: 5,
                              points: PolylinePoints()
                                  .decodePolyline(_polyline)
                                  .map((e) => LatLng(e.latitude, e.longitude))
                                  .toList(),
                            ),
                        },
                        onMapCreated: (controller) {
                          _googleMapController = controller;
                          _createOriginMarker();
                        },
                        markers: {
                          if (_originMarker != null) _originMarker!,
                        },
                        myLocationButtonEnabled: false,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(_locationData.latitude!,
                                _locationData.longitude!),
                            zoom: 16),
                      )),
                  Positioned(
                    top: 0,
                    left: size.width * 0.05,
                    child: Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        onEditingComplete: () async {
                          FocusScope.of(context).unfocus();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PlacesResultsScreen(
                                  searchString: searchController.text,
                                  originLatitude: _locationData.latitude!,
                                  originLongitude: _locationData.longitude!),
                            ),
                          );
                        },
                        controller: searchController,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          fillColor: Theme.of(context).backgroundColor,
                          filled: true,
                          contentPadding: EdgeInsets.all(13),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                              width: 2,
                            ),
                          ),
                          hintText: "Search",
                          labelStyle: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                          ),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Getting your location...',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Theme.of(context).primaryColorDark)),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.accentColor,
        foregroundColor: theme.backgroundColor,
        onPressed: () {
          if (_hasData)
            _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(
                        _locationData.latitude!, _locationData.longitude!),
                    zoom: 16),
              ),
            );
        },
        child: Icon(Icons.center_focus_strong),
      ),
      endDrawer: EndDrawer(),
      bottomNavigationBar: Builder(
        builder: (ctx) => BottomNavigationBar(
          elevation: 2,
          currentIndex: _selectedNavBarIndex,
          onTap: (index) => _onIndexChanged(index, ctx),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: theme.primaryColor,
          selectedItemColor: theme.primaryColorDark,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.message_rounded,
                size: 30,
              ),
              label: 'Conversations',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.receipt_rounded,
                size: 30,
              ),
              label: 'Tickets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.place_rounded,
                size: 30,
              ),
              label: 'Places',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_wallet_rounded,
                size: 30,
              ),
              label: 'Transactions',
            ),
          ],
        ),
      ),
    );
  }
}
