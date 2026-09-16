import 'dart:async';
import '../models/location_point.dart';

class MockLocationService {
  final _controller = StreamController<LocationPoint>.broadcast();
  Timer? _timer;

  Stream<LocationPoint> get stream => _controller.stream;

  void start({
    double startLat = 21.1619,
    double startLng = -86.8515,
  }) {
    var lat = startLat;
    var lng = startLng;

    _timer?.cancel();
    _controller.add(
      LocationPoint(lat: lat, lng: lng, timestamp: DateTime.now()),
    );

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      lat += 0.00035;
      lng += 0.00025;
      _controller.add(
        LocationPoint(lat: lat, lng: lng, timestamp: DateTime.now()),
      );
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}
