# MotoGo MX — Starter Pack

Base técnica inicial para la app de mototaxi tipo inDrive.

## Objetivo
Una sola plataforma para:
- Android
- iOS
- tablets
- web/computadora

## Roles
- Pasajero
- Conductor
- Administrador

## Flujo principal
1. Pasajero inicia sesión.
2. GPS obtiene origen.
3. Pasajero elige destino.
4. La app muestra precio estimado.
5. Se publica la solicitud de viaje.
6. Un conductor disponible acepta.
7. Pasajero ve conductor, moto, placa, número económico y sindicato.
8. Se valida el inicio mediante PIN.
9. Viaje en curso con GPS, SOS, compartir viaje y chat.
10. Finaliza el viaje.
11. Se registra pago y comisión del 8%.
12. Ambas partes califican.
13. El viaje queda en historial.

## Requisitos ya fijados
- Comisión de plataforma: 8%.
- Registro de conductores con documentos y biometría.
- Número económico, placa y sindicato.
- Wallet del conductor y retiros.
- Soporte para nivel/beneficios Diamond.
- Pagos: efectivo, tarjeta y QR.
- GPS en tiempo real.
- Historial de viajes.
- Panel administrativo.
- Base de datos en la nube.
- Seguridad: PIN, SOS y compartir viaje.

## Estructura
- `lib/`: código Flutter inicial.
- `supabase/schema.sql`: esquema de base de datos.
- `docs/architecture.md`: arquitectura técnica.
- `docs/trip_flow.md`: diagrama del viaje.
- `docs/screens.md`: mapa de pantallas.
- `docs/security.md`: reglas de seguridad y permisos.

> Este paquete es un starter: todavía no contiene integración real con mapas, pagos, biometría ni notificaciones.
