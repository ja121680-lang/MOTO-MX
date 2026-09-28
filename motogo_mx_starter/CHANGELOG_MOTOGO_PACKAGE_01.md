# MotoGo MX — Paquete 01: Fundación, inicio y solicitud de viaje

Implementado sobre `motogo_mx_starter`, rama `claude/autonomous-app-production`.
No se borró ningún archivo, flujo ni lógica de negocio existente; no se hizo
despliegue a producción.

**Nota sobre esta versión:** otra sesión estaba trabajando la misma rama en
paralelo (mismo SDK de Flutter más reciente, migración `withOpacity` →
`withValues`/`CardTheme` → `CardThemeData`/dropdown `value` → `initialValue`,
`flutter_lints` agregado, y una corrección de negocio real: la comisión de
plataforma volvió de 10% a **8%**, con su propia migración de Supabase). Este
commit es un merge de ambos trabajos: se tomaron íntegras sus correcciones de
API/lints y la corrección de la comisión (consistente con este mismo paquete,
que especifica 8%), y se conservó el contenido de este paquete (paleta exacta,
navegación, i18n, las 6 pantallas) adaptado a la API más nueva. `flutter
analyze`/`flutter test` se verificaron localmente forzando temporalmente
`flutter_lints` a una versión compatible con el SDK 3.24.5 de este entorno
(el SDK más nuevo no se pudo instalar aquí por la política de red del
sandbox); el pubspec final que se commitea es el real (`flutter_lints
^6.0.0`), validado además por el propio `GA Quality Gate` de CI.

## Cambios

### Diseño obligatorio GA
- `lib/theme/app_theme.dart`: paleta actualizada a los valores exactos del
  paquete — fondo `#0B0B0B`, superficies `#161616`/`#1E1E1E`, oro principal
  `#D4AF37`, oro claro de detalle `#F4D77A`, texto `#FFFFFF`/`#C9C9C9`,
  error/SOS `#D92D20`, éxito `#2EAD68`. `AppSpace`/`AppRadius`/
  `GradientIconBadge`/`SectionHeader`/`StatusBadge`/`TextScaleToggleButton`
  se conservan sin cambios de estructura, solo de color.

### Internacionalización (estructura)
- `lib/l10n/app_strings.dart`: `LocaleConfig` (idioma y país/región como
  ajustes separados, persistidos) + `AppStrings`/`S.t()`. Español completo
  (el texto en español es la clave de búsqueda); mapas `en`/`fr`/`it`/`pt`/`de`
  reales pero vacíos — listos para recibir traducciones sin tocar las
  pantallas otra vez. Todo el texto nuevo/modificado de este paquete pasa
  por `S.t()`.

### Navegación base
- `lib/screens/main_shell_screen.dart` (nuevo): navegación real de pasajero
  con `Inicio` / `Mis viajes` / `Actividad` / `Perfil`. Reemplaza la ruta
  `/home` (antes abría `HomeScreen` directo).
- `lib/screens/my_trips_screen.dart` (nuevo): "Mis viajes" con sección de
  viaje activo (honesta: sin viaje activo real que rastrear todavía, se
  dice explícitamente) + historial/recibos leídos del `TripLedgerService`
  real (antes `trip_history_screen.dart`, que queda intacto pero sin usar,
  mostraba una lista fija de demo desconectada del ledger real que
  `PaymentScreen` sí escribe).
- `lib/screens/activity_screen.dart` (nuevo): actividad reciente basada en
  el mismo ledger real — no se inventó un backend de notificaciones que no
  existe.
- `lib/screens/profile_screen.dart` (nuevo): tamaño de letra, bloquear
  aplicación (movido desde Inicio), aviso de privacidad, y — solo en
  `kDebugMode` — el acceso a "Modo conductor"/"Panel administrador" que
  antes eran botones centrales de la pantalla de pasajero.

### Pantallas corregidas (sin romper rutas existentes)
1. **Inicio** (`home_screen.dart`): ahora es "¿A dónde vamos?" con tarjeta
   de destino accionable, "Elegir en mapa", tarjeta de seguridad compacta.
   Se quitaron los accesos técnicos ("Modo conductor", "Panel administrador",
   accesos rápidos a Wallet/Cerca de ti) del centro de la experiencia.
2. **Solicitud de viaje** (`request_ride_screen.dart`): nota para el
   conductor (opcional, 120 car.), tipo de viaje (Una persona / Con carga
   ligera), método de pago como tarjetas seleccionables (ya no hay valor
   por defecto — el usuario debe elegir), copy amigable en vez de
   "integración pendiente", botón fijo inferior deshabilitado hasta tener
   destino + método de pago.
3. **Cotización** (`fare_preview_screen.dart`): "Revisa tu viaje", placeholder
   de ruta elegante (marcado explícitamente como vista previa, no un mapa
   real), resumen con destino/tipo/nota recibidos por parámetros del paso
   anterior, desglose plegable sin mostrar la comisión de plataforma, nota
   de seguridad sobre el PIN. Se quitaron los sliders de simulación de
   distancia/tiempo (eran un afinador de demo, no parte del diseño pedido);
   la cotización usa `FareService` sin cambios, con una distancia/duración
   por defecto hasta que haya GPS real (fuera de alcance de este paquete).
4. **Buscando/Conductor asignado** (`ride_matching_screen.dart`): tiempo
   estimado durante la búsqueda, placa del conductor enmascarada
   (`lib/data/demo_driver_fixture.dart`, dato de prueba consistente en vez
   de "Conductor demo" repetido en cada widget), botones Ver seguimiento /
   Compartir / Ayuda / SOS una vez asignado el conductor. El botón SOS
   pide confirmación de dos pasos y dice explícitamente que es una función
   simulada (no hay integración real de contacto de emergencia todavía) —
   se corrigió además un error de este paquete en el que SOS quedó
   conectado por accidente a "cancelar viaje" durante el desarrollo.
5. **Seguimiento en vivo** (`live_tracking_screen.dart`): "Ubicación
   simulada" explícito cuando no hay backend, tarjeta del conductor con
   placa protegida y número económico, botón de Chat visible pero marcado
   "próximamente", SOS con confirmación de dos pasos y mensaje honesto de
   función simulada, Compartir viaje documentado como función en desarrollo
   en vez de un botón que no hacía nada.
6. **Pago y calificación** (`payment_screen.dart`, `rating_screen.dart`): el
   pasajero ya no ve el desglose de comisión de plataforma/neto del
   conductor (se mantiene sin cambios en `PricingConfig`/`TripRecord` para
   wallet/conductor/admin); tarjeta/QR se marcan "Pago simulado". Se agregó
   "Reportar un problema" en Calificar viaje. Enviar la calificación ahora
   redirige a "Mis viajes" (antes solo mostraba un `SnackBar` y no navegaba
   a ningún lado).

## Pendientes externos / dependencias reales

Ninguno de estos se simuló como si ya funcionara — quedan explícitamente
como pendientes en la interfaz:

- GPS real de pasajero (origen/ruta en el mapa) — el conductor ya usa
  `geolocator` real; el pasajero todavía no.
- Proveedor de mapas real (la vista de ruta y el mapa de seguimiento son
  placeholders visuales).
- Pagos reales con tarjeta/QR (marcados "Pago simulado").
- Chat en tiempo real entre pasajero y conductor.
- Integración real de SOS con un contacto de emergencia/soporte.
- Compartir viaje con un enlace real en tiempo real.
- Traducciones reales de `en`/`fr`/`it`/`pt`/`de` (la estructura y todos los
  puntos de llamada ya existen vía `S.t()`; falta llenar los mapas).

## Verificación

- `flutter analyze`: 0 errores (1 warning preexistente y ajeno a este
  paquete: falta `flutter_lints` como dev_dependency en `pubspec.yaml`).
- `flutter test`: 24/24 pruebas pasando, incluyendo el widget test que
  arranca la app hasta la pantalla de entrada.
- Flujo manual revisado en código: inicio → solicitud → cotización →
  matching → seguimiento → pago → calificación → historial (Mis viajes).
- `webdeploy/` reconstruido con `flutter build web -o webdeploy` para la
  vista previa en Vercel.
