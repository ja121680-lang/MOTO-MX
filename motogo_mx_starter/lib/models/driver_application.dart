import 'dart:convert';

import 'driver_registration.dart';

enum DriverApplicationStatus { pending, approved, rejected, needsCorrection }

extension DriverApplicationStatusLabel on DriverApplicationStatus {
  String get label {
    switch (this) {
      case DriverApplicationStatus.pending:
        return 'Pendiente';
      case DriverApplicationStatus.approved:
        return 'Aprobado';
      case DriverApplicationStatus.rejected:
        return 'Rechazado';
      case DriverApplicationStatus.needsCorrection:
        return 'Requiere corrección';
    }
  }
}

/// One decision made on an application — kept as a log, not just a single
/// current status, so admin actions leave a real audit trail instead of
/// silently overwriting the previous decision.
class DriverApplicationDecision {
  const DriverApplicationDecision({
    required this.status,
    required this.decidedAt,
    this.reason,
  });

  final DriverApplicationStatus status;
  final DateTime decidedAt;
  final String? reason;

  Map<String, dynamic> toJson() => {
        'status': status.name,
        'decidedAt': decidedAt.toIso8601String(),
        'reason': reason,
      };

  static DriverApplicationDecision fromJson(Map<String, dynamic> json) =>
      DriverApplicationDecision(
        status: DriverApplicationStatus.values.byName(json['status'] as String),
        decidedAt: DateTime.parse(json['decidedAt'] as String),
        reason: json['reason'] as String?,
      );
}

/// A driver's registration as something admin can queue, review and decide
/// on — [DriverRegistrationData] alone has no id, status or audit trail, so
/// it can't represent "one of several applications in a review queue".
class DriverApplication {
  DriverApplication({
    required this.id,
    required this.data,
    required this.submittedAt,
    this.status = DriverApplicationStatus.pending,
    List<DriverApplicationDecision>? decisions,
  }) : decisions = decisions ?? [];

  final String id;
  final DriverRegistrationData data;
  final DateTime submittedAt;
  DriverApplicationStatus status;
  final List<DriverApplicationDecision> decisions;

  void decide(DriverApplicationStatus newStatus, {String? reason}) {
    status = newStatus;
    decisions.add(DriverApplicationDecision(
      status: newStatus,
      decidedAt: DateTime.now(),
      reason: reason,
    ));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': data.toJson(),
        'submittedAt': submittedAt.toIso8601String(),
        'status': status.name,
        'decisions': decisions.map((d) => d.toJson()).toList(),
      };

  static DriverApplication fromJson(Map<String, dynamic> json) => DriverApplication(
        id: json['id'] as String,
        data: DriverRegistrationData.fromJson(json['data'] as Map<String, dynamic>),
        submittedAt: DateTime.parse(json['submittedAt'] as String),
        status: DriverApplicationStatus.values.byName(json['status'] as String),
        decisions: (json['decisions'] as List<dynamic>? ?? [])
            .map((d) => DriverApplicationDecision.fromJson(d as Map<String, dynamic>))
            .toList(),
      );

  String encode() => jsonEncode(toJson());
  static DriverApplication decode(String raw) =>
      DriverApplication.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
