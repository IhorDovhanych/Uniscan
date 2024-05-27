import 'package:geolocator/geolocator.dart';

abstract class GeoPositionService {
  Future<Position> _determinePosition();
}

class GeoPositionServiceImpl implements GeoPositionService {
  GeoPositionServiceImpl();

  Future<Position> _determinePosition() async {
  await _ensureLocationServiceEnabled();
  await _ensurePermissionsGranted();
  return await Geolocator.getCurrentPosition();
}

Future<void> _ensureLocationServiceEnabled() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Future.error('Location services are disabled.');
  }
}

Future<void> _ensurePermissionsGranted() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    throw Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}
}
