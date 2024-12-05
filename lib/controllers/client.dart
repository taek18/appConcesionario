import 'package:hive/hive.dart';

part 'client.g.dart';

@HiveType(typeId: 1)
class Client extends HiveObject {
  @HiveField(0)
  String clientId; 

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  bool hasAppointment;

  Client({
    required this.clientId, 
    required this.name,
    required this.email,
    required this.phone,
    this.hasAppointment = false,
  });
}
