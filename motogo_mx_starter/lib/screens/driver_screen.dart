import 'package:flutter/material.dart';
import '../theme/ga_theme.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  bool online = false;

  Widget _metric(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: GAColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: GAColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: GAColors.goldLight, size: 24),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(color: GAColors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(color: GAColors.muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _action(BuildContext context, IconData icon, String title, String subtitle, String route) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        minVerticalPadding: 14,
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF211A08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: GAColors.goldDark),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: GAColors.goldLight, size: 25),
        ),
        title: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 14, color: GAColors.muted)),
        trailing: const Icon(Icons.chevron_right_rounded, color: GAColors.goldLight, size: 28),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modo conductor')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: online
                      ? const [Color(0xFF102A1B), Color(0xFF07110B)]
                      : const [Color(0xFF17130A), Color(0xFF0A0A0A)],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: online ? GAColors.success : GAColors.goldDark, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: online ? const Color(0xFF173F28) : const Color(0xFF211A08),
                    ),
                    child: Icon(online ? Icons.online_prediction_rounded : Icons.power_settings_new_rounded, color: online ? GAColors.success : GAColors.goldLight, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(online ? 'CONECTADO' : 'DESCONECTADO', style: TextStyle(color: online ? GAColors.success : GAColors.goldLight, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        const SizedBox(height: 5),
                        Text(online ? 'Disponible para solicitudes' : 'No recibirás solicitudes', style: const TextStyle(color: GAColors.white, fontSize: 19, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  Switch(
                    value: online,
                    activeColor: GAColors.success,
                    onChanged: (v) => setState(() => online = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _metric('Ganancias hoy', '\$0', Icons.payments_rounded),
                const SizedBox(width: 10),
                _metric('Viajes hoy', '0', Icons.route_rounded),
                const SizedBox(width: 10),
                _metric('Rating', '—', Icons.star_rounded),
              ],
            ),
            const SizedBox(height: 20),
            if (online)
              Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF101A14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GAColors.success.withOpacity(.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.radar_rounded, color: GAColors.success, size: 30),
                    SizedBox(width: 12),
                    Expanded(child: Text('Buscando solicitudes cercanas…', style: TextStyle(color: GAColors.white, fontSize: 16, fontWeight: FontWeight.w800))),
                  ],
                ),
              ),
            FilledButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/driver-registration'),
              icon: const Icon(Icons.badge_outlined),
              label: const Text('REGISTRO DE CONDUCTOR'),
            ),
            const SizedBox(height: 18),
            _action(context, Icons.account_balance_wallet_rounded, 'Wallet', 'Saldo, comisiones y retiros', '/wallet'),
            _action(context, Icons.diamond_rounded, 'Diamantes', 'Progreso, nivel y beneficios', '/diamond'),
            _action(context, Icons.history_rounded, 'Historial', 'Viajes y movimientos', '/history'),
          ],
        ),
      ),
    );
  }
}
