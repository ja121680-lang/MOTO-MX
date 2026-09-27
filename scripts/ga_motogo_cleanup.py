from pathlib import Path

ROOT = Path('motogo_mx_starter/lib')

def replace(path, old, new):
    p = ROOT / path
    text = p.read_text(encoding='utf-8')
    if new in text:
        return
    if old not in text:
        raise SystemExit(f'Missing cleanup anchor in {path}: {old[:60]}')
    p.write_text(text.replace(old, new), encoding='utf-8')

replace('screens/driver_screen.dart', 'activeColor: GAColors.success,', 'activeThumbColor: GAColors.success,')
replace('screens/driver_screen.dart', 'GAColors.success.withOpacity(.5)', 'GAColors.success.withValues(alpha: .5)')
replace('screens/request_ride_screen.dart', 'value: paymentMethod,', 'initialValue: paymentMethod,')
replace(
    'widgets/ga_assistant.dart',
    "localeId: 'es_MX',\n      listenOptions: stt.SpeechListenOptions(\n        listenMode: stt.ListenMode.confirmation,",
    "listenOptions: stt.SpeechListenOptions(\n        localeId: 'es_MX',\n        listenMode: stt.ListenMode.confirmation,",
)
print('GA MotoGo analyzer cleanup applied.')
