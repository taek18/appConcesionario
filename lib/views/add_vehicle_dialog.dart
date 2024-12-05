import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleDialog extends StatefulWidget {
  final void Function(String model, String name, String imagePath) onAddVehicle;

  const AddVehicleDialog({super.key, required this.onAddVehicle});

  @override
  State<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<AddVehicleDialog> {
  final TextEditingController modelController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  File? imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Imagen agregada con éxito'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se seleccionó ninguna imagen'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Vehículo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Agregar Imagen'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: modelController,
            decoration: const InputDecoration(
              labelText: 'Modelo del Vehículo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Vehículo',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (modelController.text.isNotEmpty &&
                nameController.text.isNotEmpty &&
                imageFile != null) {
              widget.onAddVehicle(
                modelController.text,
                nameController.text,
                imageFile!.path,
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, completa todos los campos'),
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
