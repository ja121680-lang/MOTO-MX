# Seguridad y permisos

## Reglas mínimas
- Cada usuario solo puede leer y modificar su propio perfil, salvo administrador.
- Un pasajero solo puede ver un conductor cuando existe un viaje autorizado entre ambos.
- Un conductor solo puede aceptar viajes si está aprobado y disponible.
- La comisión del 8% se calcula en servidor/backend.
- Los retiros se validan en backend.
- Los documentos privados no deben ser públicos.
- El PIN de viaje no debe guardarse en texto plano.
- Eventos SOS deben conservar trazabilidad.
- Cambios administrativos deben quedar auditados.
- Ubicación en tiempo real debe limitarse al contexto del viaje.

## Pendientes de producción
- proveedor de identidad/biometría
- cifrado y gestión de secretos
- políticas de retención de datos
- consentimiento de ubicación
- privacidad y términos
- cumplimiento de pagos
