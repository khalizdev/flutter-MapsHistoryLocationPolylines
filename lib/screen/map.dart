import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tubesmobapp/services/geolocation.dart';

class AllMap extends StatefulWidget {
  final Position positions;
  AllMap(this.positions);
  @override
  State<StatefulWidget> createState() => _AllMapState();
}

class _AllMapState extends State<AllMap> {
  final LocatorService geolocatorService = LocatorService();
  Completer<GoogleMapController> control = Completer();
  @override
  void initState() {
    geolocatorService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 500,
        height: 400,
        padding: EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Stack(
          children: <Widget>[
            GoogleMap(
            initialCameraPosition: CameraPosition(
            target:
                  LatLng(widget.positions.latitude, widget.positions.longitude),
            zoom: 18.0),
            myLocationEnabled: true,
            
            onMapCreated: (GoogleMapController controll) {
            control.complete(controll);
            },           
          ),
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 370),
          child: TextFormField(
            decoration: InputDecoration(
            labelText: 'Step Record 29/3'
            ),
            
            )
          ),
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 420),
          child: TextFormField(
            decoration: InputDecoration(
            labelText: 'Step Record 28/3'
            ),
            )
          ),
          Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 470),
          child: TextFormField(
            decoration: InputDecoration(
            labelText: 'Step Record 27/3'
            ),
            )
          ),
        ],
        )
      ),
    );
  }

  Future<Void> centerScreen(Position position) async {
    final GoogleMapController controller = await control.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }
}