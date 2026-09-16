# Funciones backend previstas

## Conductores
- `submit_driver_registration(driver_id)`
  - valida campos obligatorios
  - exige biometría y documentos
  - cambia estado a pendiente de revisión

- `review_driver_document(document_id, decision, reason)`
  - solo administrador
  - aprueba/rechaza documento
  - registra auditoría

- `approve_driver(driver_id)`
  - requiere todos los documentos aprobados
  - cambia cuenta a activa
  - habilita disponibilidad

## Viajes
- `request_trip(passenger_id, origin, destination, payment_method)`
  - valida pasajero activo
  - calcula tarifa
  - crea viaje `requested`

- `find_candidate_drivers(trip_id)`
  - busca conductores aprobados, activos y disponibles
  - prioriza cercanía y reglas operativas

- `accept_trip(trip_id, driver_id)`
  - bloqueo transaccional para evitar doble aceptación
  - asigna conductor y vehículo
  - cambia estado a `accepted`

- `verify_trip_pin(trip_id, pin)`
  - compara hash
  - si coincide cambia a `in_progress`

- `complete_trip(trip_id)`
  - fija tarifa final
  - calcula comisión 8%
  - calcula neto del conductor
  - crea movimientos de wallet
  - deja pago pendiente o pagado según método

## Seguridad
- `trigger_sos(trip_id, user_id, location)`
  - crea evento crítico
  - registra auditoría
  - dispara notificaciones

## Principios técnicos
- comisión, wallet, aprobación y estados críticos se resuelven en backend
- operaciones de aceptación y finalización deben ser transaccionales
- nunca confiar en valores enviados por el teléfono para importes o permisos
