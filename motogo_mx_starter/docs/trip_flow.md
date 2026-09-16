# Flujo de viaje

```mermaid
stateDiagram-v2
    [*] --> Solicitado
    Solicitado --> Aceptado: conductor acepta
    Aceptado --> ConductorEnCamino
    ConductorEnCamino --> PIN: conductor llega
    PIN --> EnCurso: PIN válido
    EnCurso --> Completado: llegada destino
    Completado --> Pago
    Pago --> Calificacion
    Calificacion --> [*]

    Solicitado --> Cancelado
    Aceptado --> Cancelado
    ConductorEnCamino --> Cancelado
```

## Datos visibles al pasajero tras aceptación
- nombre del conductor
- foto
- moto
- placa
- número económico
- sindicato
- calificación
- ubicación en tiempo real

## Seguridad
- PIN de inicio
- SOS
- compartir viaje
- registro de eventos críticos
