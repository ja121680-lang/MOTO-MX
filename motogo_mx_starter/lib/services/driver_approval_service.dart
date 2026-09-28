import 'package:shared_preferences/shared_preferences.dart';

import '../models/driver_application.dart';
import '../models/driver_registration.dart';

/// Local queue of driver applications — what [DriverRegistrationScreen]
/// submits into and what [DriverApprovalScreen]/the admin dashboard read
/// from. This is a single-device demo (no shared backend is configured by
/// default), so "the review queue" is whatever has been submitted from
/// this same device — real and consistent within that scope, not a
/// simulation of a multi-device system that isn't there yet.
class DriverApprovalService {
  static const _key = 'motogo_driver_applications';

  /// The application tied to this device's current driver registration
  /// draft, if one has been submitted. `null` before the driver has
  /// completed and submitted registration.
  static const _currentApplicationIdKey = 'motogo_current_application_id';

  Future<List<DriverApplication>> _all() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map(DriverApplication.decode).toList();
  }

  Future<void> _saveAll(List<DriverApplication> apps) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, apps.map((a) => a.encode()).toList());
  }

  Future<List<DriverApplication>> pending() async {
    final apps = await _all();
    return apps.where((a) => a.status == DriverApplicationStatus.pending).toList()
      ..sort((a, b) => a.submittedAt.compareTo(b.submittedAt));
  }

  Future<List<DriverApplication>> all() async {
    final apps = await _all();
    return apps..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  /// Submits (or re-submits, after a correction) [data] as a fresh pending
  /// application tied to this device.
  Future<DriverApplication> submit(DriverRegistrationData data) async {
    final apps = await _all();
    final application = DriverApplication(
      id: 'drv_app_${DateTime.now().millisecondsSinceEpoch}',
      data: data,
      submittedAt: DateTime.now(),
    );
    apps.add(application);
    await _saveAll(apps);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentApplicationIdKey, application.id);
    return application;
  }

  Future<void> decide(String applicationId, DriverApplicationStatus status, {String? reason}) async {
    final apps = await _all();
    final index = apps.indexWhere((a) => a.id == applicationId);
    if (index == -1) return;
    apps[index].decide(status, reason: reason);
    await _saveAll(apps);
  }

  /// This device's own driver application, if it has submitted one — used
  /// to gate [DriverScreen]'s "Disponible" toggle on real approval status
  /// instead of always allowing it.
  Future<DriverApplication?> currentApplication() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_currentApplicationIdKey);
    if (id == null) return null;
    final apps = await _all();
    try {
      return apps.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
