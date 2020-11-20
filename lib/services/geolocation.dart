import 'package:geolocator/geolocator.dart';
class LocatorService {
  final Geolocator geolocator = Geolocator();
  Stream<Position> getCurrentLocation() {
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    return geolocator.getPositionStream(locationOptions);
  }

  Future<Position> getInitialLocation() async {
    return geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}