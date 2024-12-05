import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/appointment.dart';
import 'package:proyecto_integrador/controllers/client.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Appointment? appointment;
  final int? index;
  final Function(Appointment, int?) onSave;

  const EditAppointmentScreen({
    super.key,
    this.appointment,
    this.index,
    required this.onSave,
  });

  @override
  EditAppointmentScreenState createState() => EditAppointmentScreenState();
}

class EditAppointmentScreenState extends State<EditAppointmentScreen> {
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  int? _selectedClientIndex;

  late Box<Client> clientsBox;

  @override
  void initState() {
    super.initState();
    clientsBox = Hive.box<Client>('clientes');

    _selectedClientIndex =
        widget.appointment != null && widget.appointment!.clientName.isNotEmpty
            ? clientsBox.values.toList().indexWhere(
                  (client) => client.name == widget.appointment!.clientName,
                )
            : null;

    if (_selectedClientIndex == -1) {
      _selectedClientIndex = null;
    }

    _selectedDate = widget.appointment?.date ?? DateTime.now();
    _selectedTime = widget.appointment != null
        ? widget.appointment!.timeOfDay
        : TimeOfDay.now();

    _dateController = TextEditingController(
      text: _selectedDate.toLocal().toString().split(' ')[0],
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.appointment != null ? 'Editar Cita' : 'Agregar Cita'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: clientsBox.listenable(),
              builder: (context, Box<Client> box, _) {
                if (box.isEmpty) {
                  return const Text('No hay clientes disponibles.');
                }
                final clients = box.values.toList();
                return DropdownButtonFormField<int>(
                  value: _selectedClientIndex,
                  onChanged: (value) {
                    setState(() {
                      _selectedClientIndex = value!;
                    });
                  },
                  items: clients.asMap().entries.map<DropdownMenuItem<int>>(
                    (entry) {
                      final index = entry.key;
                      final client = entry.value;
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(client.name),
                      );
                    },
                  ).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar Cliente',
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha seleccionada',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectTime(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: _selectedTime.format(context),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Hora seleccionada',
                    suffixIcon: const Icon(Icons.access_time),
                    hintText: _selectedTime.format(context),
                  ),
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_selectedClientIndex == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debe seleccionar un cliente.'),
                    ),
                  );
                  return;
                }

                final selectedClient = _selectedClientIndex != null
                    ? clientsBox.getAt(_selectedClientIndex!)
                    : null;

                if (selectedClient == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El cliente seleccionado no es válido.'),
                    ),
                  );
                  return;
                }

                final newAppointment = Appointment(
                  clientId: _selectedClientIndex!.toString(),
                  date: _selectedDate,
                  clientName: selectedClient.name,
                  time: '${_selectedTime.hour}:${_selectedTime.minute}',
                );

                widget.onSave(newAppointment, widget.index);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
