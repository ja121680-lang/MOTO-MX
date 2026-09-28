/// Consistent test/demo passenger + trip request data for the driver-side
/// incoming-request flow (Paquete B), matching [DemoDriverFixture]'s role
/// on the passenger side — one fixture instead of retyping the same demo
/// numbers into each widget that needs them.
class DemoPassengerFixture {
  static const String name = 'Ana R.';
  static const String pickup = 'Av. Constituyentes esq. 10 Norte';
  static const String destination = 'Plaza Pelícanos';
  static const double distanceToPassengerKm = 1.2;
  static const double fare = 78.0;
  static const String paymentMethod = 'Efectivo';
  static const String note = 'Traigo una maleta pequeña, gracias.';
  static const int secondsToRespond = 15;
}
