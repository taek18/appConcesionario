import 'package:flutter/material.dart';
import 'package:proyecto_integrador/controllers/appointment.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/client.dart';

class AddAppointmentDialog extends StatefulWidget {
  final Function(Appointment, int?) onSave;

  const AddAppointmentDialog({
    super.key,
    required this.onSave,
  });

  @override
  AddAppointmentDialogState createState() => AddAppointmentDialogState();
}

class AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  Client? selectedClient;
  late Box<Client> clientBox;
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clients');
    timeController.text = ''; // Inicializa el timeController vacío
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterialDialog();
  }

  Widget _buildMaterialDialog() {
    return AlertDialog(
      title: const Text('Nueva Cita'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          TextField(
            controller: clientNameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Cliente',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () => _showClientSelectionDialog(context),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(
              labelText: 'Fecha de la Cita',
              border: OutlineInputBorder(),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: timeController,
            decoration: InputDecoration(
              labelText: 'Hora de la Cita',
              border: const OutlineInputBorder(),
              hintText: timeController.text.isEmpty ? 'Seleccionar hora' : null,
            ),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: selectedTime,
              );
              if (picked != null) {
                setState(() {
                  selectedTime = picked;
                  timeController.text =
                      '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'; // Actualiza el controlador
                });
              }
            },
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
            if (clientNameController.text.isNotEmpty &&
                dateController.text.isNotEmpty &&
                timeController.text.isNotEmpty) {
              final newAppointment = Appointment(
                clientId: selectedClient?.clientId ?? '',
                date: selectedDate,
                clientName: clientNameController.text,
                time: timeController.text,
              );
              widget.onSave(newAppointment, null);
              Navigator.of(context).pop();
            } else {
              _showToast('Por favor, completa todos los campos');
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  void _showClientSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Cliente'),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: clientBox.length,
              itemBuilder: (context, index) {
                final client = clientBox.getAt(index);
                return ListTile(
                  title: Text(client!.name),
                  onTap: () {
                    setState(() {
                      selectedClient = client;
                      clientNameController.text = client.name;
                    });
                    Navigator.pushNamed(context, '/appointments');
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100.0,
        left: MediaQuery.of(context).size.width * 0.2,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
  }
}
