# MotoGo MX — MVP completo (Paquetes A, B y C)

Implementado sobre `motogo_mx_starter`, rama `claude/autonomous-app-production`.
No se borró código, rutas, pantallas ni el esquema Supabase existente; no se
hizo merge ni despliegue a producción. Este documento extiende
`CHANGELOG_MOTOGO_PACKAGE_01.md` (Paquete A ya cubierto ahí) con el trabajo
de Paquetes A (ajustes finales), B (conductor) y C (administrador).

## Paquete A — Pasajero (ajustes sobre el Paquete 01)

- **PIN de viaje con reintento limitado** (`ride_matching_screen.dart`):
  3 intentos, error visible, y botón "Cancelar viaje" cuando se agotan —
  antes un PIN incorrecto no mostraba nada y permitía intentos infinitos.
- El resto de Paquete A (Inicio, Solicitud, Cotización, Matching,
  Seguimiento, Pago/Calificación, navegación con Mis viajes/Actividad/
  Perfil, i18n) ya estaba implementado en el Paquete 01 — ver ese
  changelog para el detalle completo.

## Paquete B — Conductor

### Servicios y modelos nuevos
- `models/driver_application.dart` + `services/driver_approval_service.dart`:
  cola real de solicitudes de conductor (antes solo existía un borrador
  anónimo sin cola ni bitácora). Cada solicitud tiene id, estado
  (pendiente/aprobado/rechazado/requiere corrección) y un log de
  decisiones con motivo y fecha.
- `models/withdrawal_request.dart` + `services/withdrawal_service.dart`:
  solicitudes de retiro reales (monto, método, estado
  solicitado/aprobado/pagado) — antes el formulario de retiro solo
  mostraba un `SnackBar` y no guardaba nada.
- `models/sos_event.dart` + `services/sos_event_service.dart`: registro
  local de cada SOS activado (pasajero o conductor), con hora y estado de
  atención — antes los botones SOS de seguimiento/matching no hacían
  nada (`onPressed: () {}`).
- `services/fare_config_store.dart`: persiste overrides de tarifa base/
  por km/por minuto/mínima para que admin pueda editarlas.
- `data/demo_passenger_fixture.dart`: datos de pasajero de prueba
  consistentes para el flujo de solicitud entrante del conductor.

### Pantallas
1. **Registro de conductor** (`driver_registration_screen.dart`): ya
   tenía Stepper de 6 pasos con validación; ahora el paso final
   realmente envía la solicitud a `DriverApprovalService` (antes solo
   mostraba un mensaje). Texto de documento cambiado a "Documento listo
   para revisión" en vez de "Foto guardada".
2. **Inicio conductor** (`driver_screen.dart`): el interruptor
   "Disponible" ahora está bloqueado hasta que la solicitud esté
   aprobada (antes siempre se podía activar). Muestra el estado real de
   la solicitud (pendiente/rechazada/requiere corrección/aprobada),
   ganancias de hoy calculadas del ledger real, y acceso a "Simular
   solicitud entrante".
3. **Solicitud entrante** (`incoming_request_screen.dart`, nueva):
   tarjeta con recogida, destino, distancia, precio, método de pago y
   nota del pasajero; cuenta regresiva de 15s visible con auto-rechazo
   al expirar; Aceptar/Rechazar grandes.
4. **Validación de PIN / viaje** (`driver_trip_screen.dart`, nueva): pide
   el PIN antes de iniciar (nunca automático), 3 intentos con error
   claro, luego viaje en curso con ruta demo, Compartir (simulado), SOS
   (confirmación de dos pasos + registro real), y Finalizar viaje —
   finalizar escribe un `TripRecord` real en el mismo ledger que usa
   `PaymentScreen`, así que Wallet y Corte de caja lo reflejan de
   inmediato.
5. **Wallet** (`wallet_screen.dart`): reescrita para calcular saldo y
   movimientos del ledger real + retiros reales, en vez de
   `demoSummary()`/`demoTransactions()` fijos. Cada movimiento muestra
   viaje/monto bruto/comisión/neto/fecha (viajes) o
   monto/método/estado (retiros). Aviso agregado: "Los pagos y retiros
   reales requieren validación operativa."
6. **Retiro** (`withdrawal_screen.dart`): ahora crea una solicitud real
   vía `WithdrawalService` en vez de solo mostrar un mensaje.
7. **Nivel Diamond** (`diamond_screen.dart`): se agregó el aviso
   "Beneficios en definición operativa" — los criterios de calificación
   son la regla vigente, pero el alcance de cada beneficio no está
   publicado como final.

## Paquete C — Administrador

- **Dashboard** (`admin_screen.dart`, reescrita): de una lista simple de
  4 accesos a un centro de control con 6 tarjetas: viajes activos y
  conductores disponibles (honestamente "N/D" — ver pendientes),
  conductores pendientes (real, de `DriverApprovalService`), alertas SOS
  activas (real, de `SosEventService`), comisiones de hoy (real, del
  ledger) y retiros pendientes (real, de `WithdrawalService`).
- **Aprobación de conductores** (`driver_approval_screen.dart`,
  reescrita): de una pantalla con un solo borrador anónimo y una
  decisión que se perdía al salir, a una cola real de solicitudes con
  expediente completo por conductor, motivo obligatorio al rechazar o
  pedir corrección, y bitácora de decisiones visible.
- **Viajes** (`admin_trips_screen.dart`, nueva): lista real de viajes
  completados con chips de filtro (Todos/Completado/Cancelado/
  Incidencia) — "Cancelado" e "Incidencia" muestran vacío
  honestamente, porque la app todavía no persiste esos estados en
  ningún lado (cancelar una solicitud hoy solo cierra la pantalla, no
  guarda un registro).
- **Seguridad / SOS** (`sos_alerts_screen.dart`, nueva): lista real de
  activaciones SOS (pasajero o conductor) con hora y botón "Marcar
  atendida" — registro local real, no monitoreo en vivo.
- **Tarifas** (`fare_config_screen.dart`, nueva): edita tarifa base, por
  km, por minuto y mínima, con confirmación explícita antes de guardar.
  Zona única por ahora (tarifas por zona necesitan un modelo de zonas).
- Comisión / Corte de caja (`corte_de_caja_screen.dart`) ya calculaba
  totales reales del ledger — sin cambios de fondo, solo enlazado desde
  el nuevo dashboard.

## Reglas de seguridad verificadas

- PIN obligatorio antes de iniciar viaje (pasajero y conductor), nunca
  automático.
- SOS siempre visible durante el viaje, en las tres pantallas relevantes
  (seguimiento del pasajero, matching, viaje del conductor), con
  confirmación de dos pasos y registro real.
- Compartir viaje presente en todos los puntos que lo requieren, marcado
  como función simulada donde no hay backend real.
- Placa del conductor parcialmente oculta para el pasajero
  (`DemoDriverFixture.maskedPlate`) antes y durante la asignación.
- Conductor no puede activarse sin aprobación (`driver_screen.dart`
  bloquea el interruptor).
- Sin datos personales reales quemados en código — todos los fixtures
  están marcados como datos de prueba en `lib/data/`.

## Pendientes externos (ninguno se simuló como si ya funcionara)

- OTP / Supabase Auth real para pasajeros y conductores.
- Mapas/GPS real del lado del pasajero (el conductor ya usa `geolocator`
  real; las áreas de mapa siguen siendo placeholders visuales).
- Rutas/ETA reales (dependen del proveedor de mapas).
- Pagos con tarjeta/QR reales (marcados "Pago simulado").
- Biometría: ya es real vía `local_auth` del dispositivo (no simulada),
  pero no hay verificación de identidad server-side.
- Chat en tiempo real pasajero-conductor.
- Notificaciones push.
- Almacenamiento de documentos en un backend real (hoy son base64 en
  `SharedPreferences`, local al dispositivo).
- RLS (Row Level Security) definitivo en Supabase — el esquema existe en
  `supabase/schema.sql` pero este build corre en modo demo local sin
  backend conectado por defecto.
- Sincronización real pasajero–conductor–admin entre dispositivos: hoy
  cada rol lee el mismo almacenamiento local de un solo dispositivo, por
  lo que "viajes activos" y "conductores disponibles" en el dashboard de
  admin se muestran honestamente como "N/D" en vez de un número
  inventado — esto requiere Supabase Realtime configurado y todos los
  roles corriendo contra el mismo backend.
- Cancelaciones e incidencias de viaje no se persisten todavía (el
  filtro de "Viajes" en admin ya está listo para mostrarlas en cuanto
  existan).
- Tarifas por zona (hoy es una sola zona/tarifa global).

## Verificación técnica

- `flutter analyze`: 0 errores (3 infos preexistentes/menores, ajenos a
  la lógica de negocio: dos avisos de estilo `use_build_context_synchronously`
  ya guardados con `mounted`, uno de `prefer_contains` en código no
  tocado por este MVP).
- `flutter test`: 32/32 pruebas pasando (8 nuevas: `driver_approval_service_test.dart`,
  `withdrawal_service_test.dart`, `sos_event_service_test.dart`).
- Flujo completo revisado en código:
  - Pasajero: Inicio → solicitar → cotización → buscar → conductor asignado
    → PIN → seguimiento → pago → calificación → historial (Mis viajes).
  - Conductor: Registro → envío a aprobación → (aprobación desde admin) →
    disponible → solicitud entrante → aceptar → PIN → viaje → wallet →
    retiro.
  - Administrador: Dashboard → aprobación de conductor → viajes → SOS →
    comisiones → tarifas.
- `webdeploy/` reconstruido con `flutter build web -o webdeploy`.
- Capturas de pantalla móviles: no generadas en este entorno (sin
  emulador Android/iOS disponible); el build web queda listo para vista
  previa visual una vez desplegado, y `flutter test`'s `widget_test.dart`
  confirma que la app arranca correctamente hasta la pantalla de
  entrada.
- No se subió a Vercel ni se hizo merge — queda pendiente de tu
  autorización explícita.
