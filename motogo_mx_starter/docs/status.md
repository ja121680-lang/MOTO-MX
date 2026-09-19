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
- Biometría simulada
- Datos de moto
- Sindicato y número económico
- Checklist/carga simulada de documentos
- Revisión administrativa por documento
- Aprobación/rechazo de conductor
- Base SQL con viajes, documentos, wallet, pagos, SOS y auditoría
- Función transaccional inicial de aceptación de viaje
- Función inicial de finalización con comisión 10% y wallet

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
- Comisión 10% visible en liquidación (antes 8%, corregido — un solo valor en lib/config/pricing_config.dart en vez de repetido en cada pantalla)
- Calificación de viaje

## Aún requiere integración real
- autenticación OTP
- proyecto Supabase real conectado (URL/anon key) para que el seguimiento en vivo deje de caer en modo DEMO
- carpetas android/ios generadas (`flutter create .`) + permisos nativos de ubicación (el starter solo tiene `lib/`, sin esas carpetas geolocator no puede pedir permiso en un dispositivo real todavía)
- conectar DriverLocationService.publishDeviceLocation() al lado del conductor durante un viaje activo (el servicio ya existe, falta wirearlo en la pantalla del conductor)
- mapas visuales (el marcador en pantalla ya usa datos reales; falta el mapa de fondo)
- rutas/distancia/ETA
- notificaciones push
- almacenamiento real de documentos
- proveedor biométrico
- chat realtime
- compartir viaje por enlace/contactos
- pagos tarjeta/QR
- RLS/políticas definitivas
- panel admin con datos reales
- pruebas automáticas
