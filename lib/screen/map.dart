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
      body: Center(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
              target:
                  LatLng(widget.positions.latitude, widget.positions.longitude),
              zoom: 18.0),
          mapType: MapType.satellite,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controll) {
            control.complete(controll);
          },
        ),
      ),
    );
  }

  Future<Void> centerScreen(Position position) async {
    final GoogleMapController controller = await control.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }
}
