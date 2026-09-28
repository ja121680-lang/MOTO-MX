import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/trip_record.dart';

class TripLedgerService {
  static const _key = 'mgx_trip_ledger';

  Future<List<TripRecord>> getTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map((s) => TripRecord.fromJson(jsonDecode(s) as Map<String, dynamic>)).toList();
  }

  Future<void> addTrip(TripRecord trip) async {
    final trips = await getTrips();
    trips.add(trip);
    await _save(trips);
  }

  Future<void> _save(List<TripRecord> trips) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, trips.map((t) => jsonEncode(t.toJson())).toList());
  }
}

/// Aggregated totals for a set of trips — the actual "corte de caja":
/// how much came in, how much is the company's cut, how much is owed to
/// drivers, broken down by how it was paid.
class CorteDeCaja {
  const CorteDeCaja({
    required this.tripCount,
    required this.totalFare,
    required this.totalPlatformFee,
    required this.totalDriverNet,
    required this.totalByMetodo,
    required this.countByMetodo,
  });

  final int tripCount;
  final double totalFare;
  final double totalPlatformFee;
  final double totalDriverNet;
  final Map<MetodoPago, double> totalByMetodo;
  final Map<MetodoPago, int> countByMetodo;
}

CorteDeCaja calcularCorteDeCaja(List<TripRecord> trips) {
  var totalFare = 0.0;
  var totalPlatformFee = 0.0;
  var totalDriverNet = 0.0;
  final totalByMetodo = {for (final m in MetodoPago.values) m: 0.0};
  final countByMetodo = {for (final m in MetodoPago.values) m: 0};

  for (final t in trips) {
    totalFare += t.fare;
    totalPlatformFee += t.platformFee;
    totalDriverNet += t.driverNet;
    totalByMetodo[t.metodoPago] = (totalByMetodo[t.metodoPago] ?? 0) + t.fare;
    countByMetodo[t.metodoPago] = (countByMetodo[t.metodoPago] ?? 0) + 1;
  }

  return CorteDeCaja(
    tripCount: trips.length,
    totalFare: totalFare,
    totalPlatformFee: totalPlatformFee,
    totalDriverNet: totalDriverNet,
    totalByMetodo: totalByMetodo,
    countByMetodo: countByMetodo,
  );
}
