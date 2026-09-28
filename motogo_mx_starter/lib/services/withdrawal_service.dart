import 'package:shared_preferences/shared_preferences.dart';

import '../models/withdrawal_request.dart';

class WithdrawalService {
  static const _key = 'motogo_withdrawal_requests';

  Future<List<WithdrawalRequest>> all() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    final requests = raw.map(WithdrawalRequest.decode).toList();
    requests.sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
    return requests;
  }

  Future<List<WithdrawalRequest>> pending() async {
    final requests = await all();
    return requests.where((r) => r.status != WithdrawalStatus.pagado).toList();
  }

  double totalRequested(List<WithdrawalRequest> requests) =>
      requests.fold(0.0, (sum, r) => sum + r.amount);

  Future<WithdrawalRequest> request({required double amount, required String method}) async {
    final requests = await all();
    final withdrawal = WithdrawalRequest(
      id: 'wd_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      method: method,
      requestedAt: DateTime.now(),
    );
    requests.add(withdrawal);
    await _saveAll(requests);
    return withdrawal;
  }

  Future<void> updateStatus(String id, WithdrawalStatus status) async {
    final requests = await all();
    final index = requests.indexWhere((r) => r.id == id);
    if (index == -1) return;
    requests[index].status = status;
    await _saveAll(requests);
  }

  Future<void> _saveAll(List<WithdrawalRequest> requests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, requests.map((r) => r.encode()).toList());
  }
}
