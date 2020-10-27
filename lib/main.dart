import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tubesmobapp/services/geolocation.dart';
import './screen/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final serviceGeo = LocatorService();
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      create: (context) => serviceGeo.getInitialLocation(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Health-Care',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<Position>(
          builder: (context, position, widget) {
            return (position != null)
                ? AllMap(position)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
