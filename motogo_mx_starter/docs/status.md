# Estado actual del starter

## Ya implementado como prototipo local
- Navegación principal
- Solicitud de viaje
- Elección de método de pago
- Simulación de matching
- Datos del conductor asignado
- Flujo conductor en camino
- PIN de inicio demo
- Viaje en curso
- Botones SOS y compartir
- Finalización de viaje
- Registro de conductor por pasos
- Verificación biométrica real del dispositivo mediante `local_auth` (huella/biometría del equipo; MotoGo MX no recibe la huella)
- Datos de moto
- Sindicato y número económico
- Captura real de fotos de documentos desde cámara/galería, guardadas localmente en el borrador de registro
- Revisión administrativa por documento
- Aprobación/rechazo de conductor
- Base SQL con viajes, documentos, wallet, pagos, SOS y auditoría
- Función transaccional inicial de aceptación de viaje
- Función inicial de finalización con comisión configurable y wallet

- GPS real del dispositivo vía `geolocator` (DriverLocationService.watchDeviceLocation) — funciona sin backend
- Seguimiento en vivo por Supabase Realtime (trip_locations) listo en código — se activa solo con SUPABASE_URL/SUPABASE_ANON_KEY reales via --dart-define; sin ellas cae de forma visible ("DEMO" en vez de "EN VIVO") a la ruta simulada anterior
- Pantalla de seguimiento GPS demo
- Cálculo de tarifa configurable
- Vista de conductores cercanos
- Modelo de presencia de conductores en base de datos
- Reglas de tarifa persistibles en base de datos

- Wallet demo y movimientos
- Solicitud de retiro Diamond
- Evaluación automática Diamond
- Historial de viajes
- Pantalla de pago con métodos reales (efectivo/transferencia/tarjeta/app en la app)
- Corte de caja real (lib/screens/corte_de_caja_screen.dart) — suma los viajes realmente completados y guardados localmente (TripLedgerService), no un número fijo de demo; desglosa comisión de la empresa, neto para conductores, y totales por método de pago
- Comisión de plataforma 8% centralizada en `lib/config/pricing_config.dart`
- Calificación de viaje
- Pruebas automáticas de lógica y servicios principales en `test/`

## Aún requiere integración real
- autenticación OTP
- proyecto Supabase real conectado (URL/anon key) para que el seguimiento en vivo deje de caer en modo DEMO
- carpetas android/ios y permisos nativos persistentes en el repositorio; CI genera Android temporalmente para validar el APK, pero la configuración nativa final debe quedar versionada antes del lanzamiento
- conectar DriverLocationService.publishDeviceLocation() al lado del conductor durante un viaje activo (el servicio ya existe, falta wirearlo en la pantalla del viaje del conductor)
- mapas visuales (el marcador en pantalla ya usa datos reales; falta el mapa de fondo)
- rutas/distancia/ETA
- notificaciones push
- almacenamiento remoto real de documentos
- chat realtime
- compartir viaje por enlace/contactos
- pagos tarjeta/QR con proveedor real
- RLS/políticas definitivas
- panel admin con datos reales
- pruebas de integración/E2E contra backend y dispositivos reales
