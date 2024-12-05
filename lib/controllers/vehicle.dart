import 'package:hive/hive.dart';

part 'vehicle.g.dart';

@HiveType(typeId: 0)
class Vehicle extends HiveObject {
  @HiveField(0)
  String model;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imagePath;

  Vehicle({
    required this.model, 
    required this.name, 
    required this.imagePath
    });
}
