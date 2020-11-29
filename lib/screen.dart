import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ScreenPage extends StatefulWidget {
  @override
  _ScreenPageState createState() => _ScreenPageState();
}


//Kelas untuk kontrol, marker, posisi, polylines ada disini
class _ScreenPageState extends State<ScreenPage> {
  GoogleMapController googleMapController;
  Marker _marker;
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  StreamSubscription<Position> _positionLokasi;
  Map<MarkerId, Marker> _markers = Map();
  Map<PolylineId, Polyline> _polilynes = Map();
  List<LatLng> _myRoutes = List();
  Position _lastPosition;

  //inisialisasi pemanggilan start track
  @override
  void initState() {
    super.initState();
    _startTrack();
  }

  //memulai pemanggilan google maps
  _startTrack(){
    final geolocator = Geolocator();
    final locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
    _positionLokasi = geolocator.getPositionStream(locationOptions).listen(_posisi);
  }


  //memulai mengambil posisi user
  _posisi(Position position){
    if(position != null)
    {
      final myPosition = LatLng(position.latitude, position.longitude);
      _myRoutes.add(myPosition);
      final myPolilyne = Polyline(polylineId: PolylineId("me"), points: _myRoutes, color: Colors.cyanAccent, width: 6);
      if(_marker == null)
        {
          final markerId = MarkerId("me");
          _marker = Marker(markerId: markerId, position: myPosition,rotation: 0, anchor: Offset(0.5, 0.5));
        }
      else
        {
          final rotation = _getMyBearing(_lastPosition, position);
          _marker = _marker.copyWith(positionParam: myPosition, rotationParam: rotation);
        }
      setState(() {
        _markers[_marker.markerId] = _marker;
        _polilynes[myPolilyne.polylineId] = myPolilyne;
      });
      _lastPosition = position;
      _pindahposisi(position);
    }
  }


  //fungsi untuk mengubah icon user
  double _getMyBearing(Position lastPosition, Position currentPosition){
  final x = math.cos(math.pi / 100 * lastPosition.latitude) * (currentPosition.longitude - lastPosition.longitude);
  final y = currentPosition.latitude - lastPosition.latitude;
  final angle = math.atan2(x, y);
  return 90 - angle + 180 / math.pi;
  }

  @override
  void dispose() {
    if(_positionLokasi != null)
      {
        _positionLokasi.cancel();
        _positionLokasi = null;
      }
    super.dispose();
  }


  //melakukan update kamera jika posisi user berpindah
  _pindahposisi(Position position)
  {
    final cameraUpdate = CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude));
    googleMapController.animateCamera(cameraUpdate);
  }


  //sistem untuk menampilkan class diatas dan fungsi diatas
  //penambahan tombol dan perbaikan ui disini
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 23.0),
        width: 500,
        height: 500,
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              polylines: Set.of(_polilynes.values),
              onMapCreated: (GoogleMapController controller)
              {
                googleMapController = controller;
              },
            )
          ],
        ),
      ),
    );
  }
}