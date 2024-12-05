import 'package:hive/hive.dart';
import 'vehicle.dart';
import 'client.dart';

part 'sales.g.dart';

@HiveType(typeId: 3) 
class Sales extends HiveObject {
  @HiveField(0)
  late Vehicle vehicle;

  @HiveField(1)
  late Client client;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late String paymentType;

  Sales({
    required this.vehicle,
    required this.client,
    required this.date,
    required this.paymentType,
  });
}
