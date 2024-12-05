import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/vehicle.dart';
import '../models/vehicle_card.dart';
import 'add_vehicle_dialog.dart';
import 'edit_vehicle_dialog.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  InventoryScreenState createState() => InventoryScreenState();
}

class InventoryScreenState extends State<InventoryScreen> {
  late Box<Vehicle> vehicleBox;

  @override
  void initState() {
    super.initState();
    vehicleBox = Hive.box<Vehicle>('inventario');
  }

  void _addVehicle(Vehicle newVehicle) {
    vehicleBox.add(newVehicle);
    setState(() {});
  }

  void _deleteVehicle(int index) {
    vehicleBox.deleteAt(index);
    setState(() {});
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddVehicleDialog(
          onAddVehicle: (model, name, imagePath) {
            final newVehicle = Vehicle(
              model: model,
              name: name,
              imagePath: imagePath,
            );
            _addVehicle(newVehicle);
          },
        );
      },
    );
  }

  void _showEditVehicleDialog(int index, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditVehicleDialog(
          vehicle: vehicle,
          onSave: (updatedVehicle) {
            vehicleBox.putAt(index, updatedVehicle);
            setState(() {});
          },
        );
      },
    );
  }

  void _showDeleteVehicleDialog(int index, Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Theme.of(context).platform == TargetPlatform.iOS) {
          return CupertinoAlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el vehículo "${vehicle.name}"?',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteVehicle(index);
                },
                isDestructiveAction: true,
                child: const Text('Eliminar'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el vehículo "${vehicle.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteVehicle(index);
                },
                child: const Text('Eliminar'),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: vehicleBox.listenable(),
        builder: (context, Box<Vehicle> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No hay vehículos en el inventario. Presione el botón para agregar un vehículo.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final vehicle = box.getAt(index)!;
              return GestureDetector(
                onTap: () => _showEditVehicleDialog(index, vehicle),
                onLongPress: () => _showDeleteVehicleDialog(index, vehicle),
                child: VehicleCard(
                  imagePath: vehicle.imagePath,
                  model: vehicle.model,
                  name: vehicle.name,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddVehicleDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
