import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'appointment.g.dart';

@HiveType(typeId: 2)
class Appointment extends HiveObject {
  @HiveField(0)
  final String clientId;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String clientName;

  @HiveField(3)
  final String time;

  TimeOfDay get timeOfDay {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Appointment({
    required this.clientId, 
    required this.date, 
    required this.clientName,
    required this.time
    });
}
