# Economía del viaje

## Liquidación
Para una tarifa final `F`:

- comisión MotoGo MX = `F × 0.08`
- neto conductor = `F × 0.92`

Ejemplo:
- tarifa: 90 MXN
- comisión 8%: 7.20 MXN
- neto conductor: 82.80 MXN

## Wallet
El conductor tiene:
- saldo disponible
- saldo pendiente
- movimientos
- créditos por viaje
- cargos de comisión
- retiros
- ajustes administrativos

## Retiros
En el starter, el retiro exige:
- conductor activo
- Diamond habilitado
- monto positivo
- saldo disponible suficiente

La solicitud de retiro bloquea el monto moviéndolo de `available_balance`
a `pending_balance` para evitar doble gasto.

## Diamond
Regla de prototipo:
- 100 viajes completados
- calificación >= 4.8
- tasa de cancelación <= 8%

Estas reglas son configurables y deben considerarse provisionales hasta definir
la política comercial final.
