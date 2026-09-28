import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';
import '../models/location_point.dart';
import 'mock_location_service.dart';

/// Real GPS + live location sharing, matching the design in
/// docs/realtime_flow.md and the `trip_locations` table in
/// supabase/schema.sql (trip_id, user_id, lat, lng, heading, speed,
/// recorded_at). Two independent pieces:
///
/// - [watchDeviceLocation] reads the *actual* device GPS via `geolocator`.
///   Works standalone, no backend needed — this is real, not simulated.
/// - [publishDeviceLocation] / [watchTripLocation] push/pull that position
///   through Supabase Realtime so a passenger sees the driver move live.
///   These need [AppConfig.isConfigured] (a real Supabase project URL +
///   anon key via --dart-define) — without it, [watchTripLocation] falls
///   back to [MockLocationService]'s simulated route so the demo still
///   works, and callers should show that clearly rather than implying a
///   live connection that isn't there.
class DriverLocationService {
  static const _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // meters between updates
  );

  /// Requests location permission if needed. Returns false if the user
  /// denied it or location services are off — callers should fall back
  /// to the mock stream and tell the user why, not fail silently.
  Future<bool> ensurePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  /// The device's real GPS position as a live stream.
  Stream<LocationPoint> watchDeviceLocation() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings).map(
      (pos) => LocationPoint(lat: pos.latitude, lng: pos.longitude, timestamp: DateTime.now()),
    );
  }

  /// Driver side: pushes a location update for this trip. No-ops (does not
  /// throw) if the backend isn't configured, so callers can call this
  /// unconditionally from a device-GPS listener.
  Future<void> publishDeviceLocation({
    required String tripId,
    required String userId,
    required LocationPoint point,
  }) async {
    if (!AppConfig.isConfigured) return;
    await Supabase.instance.client.from('trip_locations').insert({
      'trip_id': tripId,
      'user_id': userId,
      'lat': point.lat,
      'lng': point.lng,
      'recorded_at': point.timestamp.toIso8601String(),
    });
  }

  /// Passenger side: live updates for a given trip. Falls back to the
  /// simulated route when there's no real backend configured, so the demo
  /// keeps working — [isLive] tells the caller which one it's getting so
  /// the UI can label it honestly ("EN VIVO" vs "DEMO").
  Stream<LocationPoint> watchTripLocation(String tripId, {required void Function(bool isLive) onModeKnown}) {
    if (!AppConfig.isConfigured) {
      onModeKnown(false);
      final mock = MockLocationService();
      final mockController = StreamController<LocationPoint>.broadcast(
        onCancel: mock.dispose, // stop the periodic timer once nobody's listening
      );
      mock.stream.listen(mockController.add);
      mock.start();
      return mockController.stream;
    }
    onModeKnown(true);
    final controller = StreamController<LocationPoint>.broadcast();
    final channel = Supabase.instance.client
        .channel('trip_locations:$tripId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'trip_locations',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'trip_id', value: tripId),
          callback: (payload) {
            final row = payload.newRecord;
            controller.add(LocationPoint(
              lat: (row['lat'] as num).toDouble(),
              lng: (row['lng'] as num).toDouble(),
              timestamp: DateTime.tryParse(row['recorded_at'] as String? ?? '') ?? DateTime.now(),
            ));
          },
        )
        .subscribe();
    controller.onCancel = () => Supabase.instance.client.removeChannel(channel);
    return controller.stream;
  }
}
