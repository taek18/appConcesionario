import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/appointment.dart';
import 'package:table_calendar/table_calendar.dart';
import 'edit_appointment_screen.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  AppointmentsScreenState createState() => AppointmentsScreenState();
}

class AppointmentsScreenState extends State<AppointmentsScreen> {
  late Box<Appointment> appointmentBox;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    appointmentBox = Hive.box<Appointment>('appointments');
  }

  List<Appointment> _getEventsForDay(DateTime day) {
    return appointmentBox.values
        .where((appointment) => isSameDay(appointment.date, day))
        .toList();
  }

  void _addOrEditAppointment({Appointment? appointment, int? index}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: EditAppointmentScreen(
            appointment: appointment,
            index: index,
            onSave: (newAppointment, index) {
              setState(() {
                if (index != null) {
                  appointmentBox.putAt(index, newAppointment);
                } else {
                  appointmentBox.add(newAppointment);
                }
              });
            },
          ),
        );
      },
    );
  }

  void _confirmDeleteAppointment(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Cita'),
          content: const Text('¿Está seguro de que desea eliminar esta cita?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  appointmentBox.deleteAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: appointmentBox.listenable(),
                builder: (context, Box<Appointment> box, _) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay ninguna cita. Presione el botón para agregar una cita.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final appointment = box.getAt(index)!;

                      final dateFormatted =
                          DateFormat('yyyy-MM-dd').format(appointment.date);

                      final timeFormatted =
                          appointment.timeOfDay.format(context);

                      return ListTile(
                        leading:
                            const Icon(Icons.person, color: Colors.deepPurple),
                        title: Text(appointment.clientName),
                        subtitle:
                            Text('Fecha: $dateFormatted\nHora: $timeFormatted'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDeleteAppointment(index),
                        ),
                        onTap: () {
                          _addOrEditAppointment(
                            appointment: appointment,
                            index: index,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addOrEditAppointment();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
