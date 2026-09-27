import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/ga_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _quickCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Expanded(
      child: Semantics(
        button: true,
        label: '$title. $subtitle',
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => Navigator.pushNamed(context, route),
          child: Container(
            constraints: const BoxConstraints(minHeight: 132),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GAColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: GAColors.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF211A08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: GAColors.goldDark),
                  ),
                  alignment: Alignment.center,
                  child: Icon(icon, color: GAColors.goldLight, size: 27),
                ),
                const SizedBox(height: 12),
                Text(title,
                    style: const TextStyle(
                        color: GAColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: GAColors.muted, fontSize: 14, height: 1.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text('GA',
                style: TextStyle(
                    color: GAColors.goldLight, fontWeight: FontWeight.w900)),
            SizedBox(width: 8),
            Text('MotoGo MX'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Historial de viajes',
            onPressed: () => Navigator.pushNamed(context, '/history'),
            icon: const Icon(Icons.history_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: GAColors.goldDark),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: SvgPicture.asset(
                    'assets/ga_motogo_hero.svg',
                    fit: BoxFit.cover,
                    semanticsLabel: 'GA MotoGo MX. Solicita un viaje en moto.',
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text('¿A dónde vas?',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: GAColors.white,
                      height: 1.05)),
              const SizedBox(height: 8),
              const Text(
                'Define tu origen y destino. Verás la tarifa antes de confirmar el viaje.',
                style: TextStyle(
                    fontSize: 16, color: GAColors.muted, height: 1.45),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/request'),
                icon: const Icon(Icons.two_wheeler_rounded, size: 27),
                label: const Text('SOLICITAR VIAJE'),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  _quickCard(
                    context: context,
                    icon: Icons.radar_rounded,
                    title: 'Cerca de ti',
                    subtitle: 'Conductores disponibles',
                    route: '/nearby-drivers',
                  ),
                  const SizedBox(width: 12),
                  _quickCard(
                    context: context,
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'Wallet',
                    subtitle: 'Saldo y movimientos',
                    route: '/wallet',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _quickCard(
                    context: context,
                    icon: Icons.route_rounded,
                    title: 'Mis viajes',
                    subtitle: 'Historial y actividad',
                    route: '/history',
                  ),
                  const SizedBox(width: 12),
                  _quickCard(
                    context: context,
                    icon: Icons.diamond_rounded,
                    title: 'Diamantes',
                    subtitle: 'Recompensas GA',
                    route: '/diamond',
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF17130A), Color(0xFF0B0B0B)]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GAColors.goldDark),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.verified_user_outlined,
                            color: GAColors.goldLight, size: 28),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text('¿Eres conductor?',
                                style: TextStyle(
                                    color: GAColors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Conéctate, revisa solicitudes y administra tus ganancias desde el modo conductor.',
                        style: TextStyle(
                            color: GAColors.muted, fontSize: 15, height: 1.4)),
                    const SizedBox(height: 14),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/driver'),
                      icon: const Icon(Icons.sports_motorsports_rounded),
                      label: const Text('ABRIR MODO CONDUCTOR'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              TextButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/admin'),
                icon: const Icon(Icons.admin_panel_settings_outlined,
                    color: GAColors.muted),
                label: const Text('Panel administrador',
                    style: TextStyle(
                        color: GAColors.muted,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
