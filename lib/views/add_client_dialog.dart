import 'package:flutter/material.dart';

class AddClientDialog extends StatelessWidget {
  final void Function(String name, String email, String phone,) onAddClient;

  const AddClientDialog({super.key, required this.onAddClient});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    return AlertDialog(
      title: const Text('Agregar Cliente'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Correo Electrónico'),
          ),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Agregar'),
          onPressed: () {
            onAddClient(
              nameController.text,
              emailController.text,
              phoneController.text,

            );
          },
        ),
      ],
    );
  }
}
