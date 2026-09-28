import 'package:shared_preferences/shared_preferences.dart';

import '../models/sos_event.dart';

class SosEventService {
  static const _key = 'motogo_sos_events';

  Future<List<SosEvent>> all() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final events = raw.map(SosEvent.decode).toList();
    events.sort((a, b) => b.triggeredAt.compareTo(a.triggeredAt));
    return events;
  }

  Future<SosEvent> log({required SosRole role, String? tripId}) async {
    final events = await all();
    final event = SosEvent(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      role: role,
      triggeredAt: DateTime.now(),
      tripId: tripId,
    );
    events.add(event);
    await _saveAll(events);
    return event;
  }

  Future<void> markAttended(String id) async {
    final events = await all();
    final index = events.indexWhere((e) => e.id == id);
    if (index == -1) return;
    events[index].attended = true;
    await _saveAll(events);
  }

  Future<void> _saveAll(List<SosEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, events.map((e) => e.encode()).toList());
  }
}
