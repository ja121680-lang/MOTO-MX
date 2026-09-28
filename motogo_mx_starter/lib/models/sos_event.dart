import 'dart:convert';

/// Who triggered an SOS — the passenger app or the driver app.
enum SosRole { passenger, driver }

/// A real, locally-logged SOS activation. This is not live monitoring (no
/// maps/permissions/operational protocol are connected yet — see
/// [AppConfig.isConfigured] and the app's pendientes list); it is an honest
/// record that an SOS button was pressed, when, by whom, and whether
/// someone has marked it attended, so the admin "Seguridad" module has
/// something real to show instead of a fabricated live feed.
class SosEvent {
  SosEvent({
    required this.id,
    required this.role,
    required this.triggeredAt,
    this.tripId,
    this.attended = false,
  });

  final String id;
  final SosRole role;
  final DateTime triggeredAt;
  final String? tripId;
  bool attended;

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': role.name,
        'triggeredAt': triggeredAt.toIso8601String(),
        'tripId': tripId,
        'attended': attended,
      };

  static SosEvent fromJson(Map<String, dynamic> json) => SosEvent(
        id: json['id'] as String,
        role: SosRole.values.byName(json['role'] as String),
        triggeredAt: DateTime.parse(json['triggeredAt'] as String),
        tripId: json['tripId'] as String?,
        attended: json['attended'] as bool? ?? false,
      );

  String encode() => jsonEncode(toJson());
  static SosEvent decode(String raw) => SosEvent.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
