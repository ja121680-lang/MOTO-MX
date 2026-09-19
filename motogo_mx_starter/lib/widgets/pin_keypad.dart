import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Teclado numérico + puntos de progreso compartido entre crear PIN y
/// desbloquear con PIN.
class PinKeypad extends StatelessWidget {
  const PinKeypad({super.key, required this.length, required this.onKeyTap, this.enabled = true});

  final int length;
  final void Function(String key) onKeyTap;
  final bool enabled;

  static const _keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final filled = i < length;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled ? AppTheme.primaryYellow : AppTheme.divider,
              ),
            );
          }),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: 260,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: _keys.map((k) {
              if (k.isEmpty) return const SizedBox.shrink();
              return Material(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: enabled ? () => onKeyTap(k) : null,
                  child: Center(
                    child: k == 'del'
                        ? const Icon(Icons.backspace_outlined, color: AppTheme.textLight)
                        : Text(k, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.textLight)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
