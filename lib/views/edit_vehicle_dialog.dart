import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_integrador/controllers/vehicle.dart';

class EditVehicleDialog extends StatefulWidget {
  final Vehicle vehicle;
  final void Function(Vehicle updatedVehicle) onSave;

  const EditVehicleDialog({
    required this.vehicle,
    required this.onSave,
    super.key,
  });

  @override
  State<EditVehicleDialog> createState() => _EditVehicleDialogState();
}

class _EditVehicleDialogState extends State<EditVehicleDialog> {
  late TextEditingController modelController;
  late TextEditingController nameController;
  String? imagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    modelController = TextEditingController(text: widget.vehicle.model);
    nameController = TextEditingController(text: widget.vehicle.name);
    imagePath = widget.vehicle.imagePath;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar vehículo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: modelController,
            decoration: const InputDecoration(labelText: 'Modelo'),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Cambiar Imagen'),
          ),
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Image.file(
                File(imagePath!),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final updatedVehicle = Vehicle(
              model: modelController.text,
              name: nameController.text,
              imagePath: imagePath ?? widget.vehicle.imagePath,
            );
            widget.onSave(updatedVehicle);
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
