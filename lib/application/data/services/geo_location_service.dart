import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

abstract class GeoLocationService {
  Future<void> getPermissions();
  Future<Position> determinePosition();
  Future<void> ensureLocationServiceEnabled();
  Future<void> ensurePermissionsGranted();
  Future<Stream<Position>> getPositionStream();
}

class GeoLocationServiceImpl implements GeoLocationService {
  GeoLocationServiceImpl();

  @override
  Future<void> getPermissions() async {
    await ensureLocationServiceEnabled();
    await ensurePermissionsGranted();
  }

  @override
  Future<Position> determinePosition() async {
    await getPermissions();
    return await Geolocator.getCurrentPosition();
  }

  @override
  Future<void> ensureLocationServiceEnabled() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Future.error('Location services are disabled.');
    }
  }

  @override
  Future<void> ensurePermissionsGranted() async {
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

  @override
  Future<Stream<Position>> getPositionStream() async {
    await getPermissions();

    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
