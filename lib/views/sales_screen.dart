import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/views/edit_sale_dialog.dart';
import 'package:proyecto_integrador/views/sales_inventory_screen.dart';
import '../controllers/sales.dart';
import '../controllers/vehicle.dart';
import '../controllers/client.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  SalesScreenState createState() => SalesScreenState();
}

class SalesScreenState extends State<SalesScreen> {
  late Box<Sales> salesBox;
  late Box<Vehicle> vehicleBox;
  late Box<Client> clientBox;

  @override
  void initState() {
    super.initState();
    salesBox = Hive.box<Sales>('ventas');
    vehicleBox = Hive.box<Vehicle>('inventario');
    clientBox = Hive.box<Client>('clientes');
  }

  void _addSale(Sales newSale) {
    salesBox.add(newSale);
    setState(() {});
  }

  void _editSale(int index, Sales updatedSale) {
    salesBox.putAt(index, updatedSale);
    setState(() {});
  }

  void _deleteSale(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta venta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                salesBox.deleteAt(index);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSaleDialog(int index, Sales sale) {
    showDialog(
      context: context,
      builder: (context) => EditSaleDialog(
        availableVehicles: vehicleBox.values.toList(),
        availableClients: clientBox.values.toList(),
        initialVehicle: sale.vehicle,
        initialClient: sale.client,
        initialDate: sale.date,
        initialPaymentType: sale.paymentType,
        initialPrice: sale.price,
        onUpdateSale: (vehicle, client, date, paymentType, price) {
          final updatedSale = Sales(
            vehicle: vehicle,
            client: client,
            date: date,
            paymentType: paymentType,
            price: price,
          );
          _editSale(index, updatedSale);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: salesBox.listenable(),
        builder: (context, Box<Sales> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No hay ninguna venta registrada',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Presione el botón para agregar una venta',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final sale = box.getAt(index)!;
              return ListTile(
                title: Text('Cliente: ${sale.client.name}'),
                subtitle: Text(
                  'Vehículo: ${sale.vehicle.name}\n'
                  'Fecha: ${DateFormat('yyyy-MM-dd').format(sale.date)}\n'
                  'Forma de Pago: ${sale.paymentType}\n'
                  'Precio: \$${sale.price.toStringAsFixed(2)}',
                ),
                onTap: () => _showEditSaleDialog(index, sale),
                onLongPress: () => _deleteSale(index),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InventoryScreenForSales(),
            ),
          );

          if (result != null) {
            final newSale = Sales(
              vehicle: result['vehicle'],
              client: result['client'],
              date: result['date'],
              paymentType: result['paymentType'],
              price: result['price'],
            );
            _addSale(newSale);
          } else {
            debugPrint('No se recibió ningún resultado.');
          }
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
