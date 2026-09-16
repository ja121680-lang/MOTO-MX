# GPS, matching y tarifas

## GPS
En el starter, el GPS está simulado con un `Stream<LocationPoint>` que cambia coordenadas cada 2 segundos.

En producción debe reemplazarse por:
- ubicación real del dispositivo
- permisos de localización
- actualización en foreground/background
- envío periódico al backend
- suscripción realtime del pasajero a la ubicación del conductor

## Matching
La selección inicial prioriza:
1. conductor aprobado
2. conductor activo
3. conductor disponible
4. cercanía / ETA
5. calificación como desempate

La aceptación definitiva debe hacerse en backend con bloqueo transaccional.

## Tarifa
Fórmula MVP:

`total = max(mínimo, base + km*precio_km + minutos*precio_minuto)`

Configuración demo:
- base: 15 MXN
- por km: 7 MXN
- por minuto: 1.20 MXN
- mínimo: 25 MXN

Estos valores son **solo configuración de prototipo**, no una tarifa comercial definitiva.

## Comisión
Después de determinar la tarifa final:
- plataforma = 8%
- conductor = 92%

La comisión se calcula en backend y nunca se confía al teléfono.
