import 'package:flutter/material.dart';
import '../models/driver_registration.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final data = DriverRegistrationData();
  int currentStep = 0;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final plateController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final economicController = TextEditingController();
  final unionController = TextEditingController();

  @override
  void dispose() {
    for (final c in [
      nameController,
      phoneController,
      emailController,
      plateController,
      makeController,
      modelController,
      colorController,
      economicController,
      unionController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void syncData() {
    data.fullName = nameController.text;
    data.phone = phoneController.text;
    data.email = emailController.text;
    data.plate = plateController.text;
    data.make = makeController.text;
    data.model = modelController.text;
    data.color = colorController.text;
    data.economicNumber = economicController.text;
    data.unionName = unionController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de conductor')),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          syncData();
          if (currentStep < 5) {
            setState(() => currentStep++);
          } else {
            final ok = data.readyForReview;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ok
                      ? 'Registro enviado a revisión.'
                      : 'Faltan datos obligatorios antes de enviar.',
                ),
              ),
            );
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() => currentStep--);
          }
        },
        steps: [
          Step(
            title: const Text('Datos personales'),
            content: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre completo'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Correo opcional'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Biometría'),
            content: SwitchListTile(
              value: data.biometricVerified,
              onChanged: (v) => setState(() => data.biometricVerified = v),
              title: const Text('Biometría verificada'),
              subtitle: const Text(
                'Simulación por ahora; después se conecta proveedor real.',
              ),
            ),
          ),
          Step(
            title: const Text('Moto'),
            content: Column(
              children: [
                TextField(
                  controller: plateController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                ),
                TextField(
                  controller: makeController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: modelController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Sindicato'),
            content: Column(
              children: [
                TextField(
                  controller: economicController,
                  decoration:
                      const InputDecoration(labelText: 'Número económico'),
                ),
                TextField(
                  controller: unionController,
                  decoration: const InputDecoration(labelText: 'Sindicato'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Documentos'),
            content: Column(
              children: data.documents.keys.map((name) {
                return CheckboxListTile(
                  value: data.documents[name],
                  onChanged: (v) =>
                      setState(() => data.documents[name] = v ?? false),
                  title: Text(name),
                  subtitle: const Text('Carga simulada'),
                );
              }).toList(),
            ),
          ),
          Step(
            title: const Text('Revisión'),
            content: Column(
              children: [
                CheckboxListTile(
                  value: data.acceptedTerms,
                  onChanged: (v) =>
                      setState(() => data.acceptedTerms = v ?? false),
                  title: const Text('Acepto términos y tratamiento de datos'),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Al enviar, la cuenta queda pendiente hasta aprobación administrativa.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
