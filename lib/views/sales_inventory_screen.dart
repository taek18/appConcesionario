import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/client.dart';
import 'package:proyecto_integrador/controllers/vehicle.dart';
import 'add_sales_dialog.dart';

class InventoryScreenForSales extends StatefulWidget {
  const InventoryScreenForSales({super.key});

  @override
  InventoryScreenForSalesState createState() => InventoryScreenForSalesState();
}

class InventoryScreenForSalesState extends State<InventoryScreenForSales> {
  late Box<Vehicle> vehicleBox;
  late Box<Client> clientBox;

  @override
  void initState() {
    super.initState();
    vehicleBox = Hive.box<Vehicle>('inventario');
    clientBox = Hive.box<Client>('clientes');
  }

  void _openAddSaleDialog(Vehicle vehicle) {
    Client? selectedClient = clientBox.isNotEmpty ? clientBox.getAt(0) : null;

    if (selectedClient != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddSaleDialog(
            availableVehicles: [vehicle],
            availableClients: clientBox.values.toList(),
            initialVehicle: vehicle,
            onAddSale: (vehicle, client, date, paymentType, price) {
              final newSale = {
                'vehicle': vehicle,
                'client': client,
                'date': date,
                'paymentType': paymentType,
                'price': price,
              };
              Navigator.of(context).pop(newSale);
            },
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay clientes disponibles.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un vehículo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: vehicleBox.listenable(),
        builder: (context, Box<Vehicle> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No hay vehículos en el inventario. Agrega algunos primero.',
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
                onTap: () => _openAddSaleDialog(vehicle),
                child: ListTile(
                  title: Text(vehicle.name),
                  subtitle: Text(vehicle.model),
                  leading: Container(
                    width: 80,  // Definir un ancho constante para la imagen
                    height: 80, // Definir una altura constante para la imagen
                    child: Image.asset(
                      vehicle.imagePath,
                      fit: BoxFit.cover,  // Asegura que la imagen no se distorsione
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
