import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/driver_registration.dart';
import '../services/driver_registration_store.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _store = DriverRegistrationStore();
  var data = DriverRegistrationData();
  int currentStep = 0;
  bool _loading = true;

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
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final saved = await _store.load();
    if (saved != null) {
      data = saved;
      nameController.text = data.fullName;
      phoneController.text = data.phone;
      emailController.text = data.email;
      plateController.text = data.plate;
      makeController.text = data.make;
      modelController.text = data.model;
      colorController.text = data.color;
      economicController.text = data.economicNumber;
      unionController.text = data.unionName;
    }
    if (mounted) setState(() => _loading = false);
  }

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

  Future<void> _saveDraft() async {
    syncData();
    await _store.save(data);
  }

  Future<void> _captureDocument(String name) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de la galería'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1600, imageQuality: 80);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() => data.documentPhotos[name] = base64Encode(bytes));
    await _saveDraft();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de conductor')),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () async {
          await _saveDraft();
          if (!mounted) return;
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
              children: kDriverDocumentNames.map((name) {
                final photo = data.documentPhotos[name];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      if (photo != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(base64Decode(photo), width: 48, height: 48, fit: BoxFit.cover),
                        )
                      else
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.description_outlined, color: Colors.grey),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name),
                            Text(
                              photo != null ? 'Foto guardada' : 'Sin foto',
                              style: TextStyle(fontSize: 12, color: photo != null ? Colors.green : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () => _captureDocument(name),
                        child: Text(photo != null ? 'Cambiar' : 'Agregar foto'),
                      ),
                    ],
                  ),
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
