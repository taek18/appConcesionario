import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/vehicle.dart';
import '../controllers/client.dart';

class EditSaleDialog extends StatefulWidget {
  final void Function(Vehicle vehicle, Client client, DateTime date,
      String paymentType, double price) onUpdateSale;
  final List<Vehicle> availableVehicles;
  final List<Client> availableClients;
  final Vehicle initialVehicle;
  final Client initialClient;
  final DateTime initialDate;
  final String initialPaymentType;
  final double initialPrice;

  const EditSaleDialog({
    super.key,
    required this.onUpdateSale,
    required this.availableVehicles,
    required this.availableClients,
    required this.initialVehicle,
    required this.initialClient,
    required this.initialDate,
    required this.initialPaymentType,
    required this.initialPrice,
  });

  @override
  State<EditSaleDialog> createState() => _EditSaleDialogState();
}

class _EditSaleDialogState extends State<EditSaleDialog> {
  late Vehicle selectedVehicle;
  late Client selectedClient;
  late TextEditingController dateController;
  late TextEditingController priceController;
  late String paymentType;
  late double price;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.initialVehicle;
    selectedClient = widget.initialClient;
    dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.initialDate),
    );
    priceController = TextEditingController(
      text: widget.initialPrice.toStringAsFixed(2),
    );
    paymentType = widget.initialPaymentType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Venta'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Vehicle>(
              value: selectedVehicle,
              decoration: const InputDecoration(labelText: 'Vehículo'),
              items: widget.availableVehicles.map((Vehicle vehicle) {
                return DropdownMenuItem<Vehicle>(
                  value: vehicle,
                  child: Text('${vehicle.name} (${vehicle.model})'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedVehicle = newValue!;
                });
              },
            ),
            DropdownButtonFormField<Client>(
              value: selectedClient,
              decoration: const InputDecoration(labelText: 'Cliente'),
              items: widget.availableClients.map((Client client) {
                return DropdownMenuItem<Client>(
                  value: client,
                  child: Text(client.name),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedClient = newValue!;
                });
              },
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Fecha de Venta'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
            ),
            DropdownButtonFormField<String>(
              value: paymentType,
              decoration: const InputDecoration(labelText: 'Forma de Pago'),
              items: ['Efectivo', 'Tarjeta', 'Cheque'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  paymentType = newValue!;
                });
              },
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  price = double.tryParse(value) ?? 0.0;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (dateController.text.isNotEmpty) {
              widget.onUpdateSale(
                selectedVehicle,
                selectedClient,
                DateTime.parse(dateController.text),
                paymentType,
                price,
              );

              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Por favor, completa todos los campos')),
              );
            }
          },
          child: const Text('Guardar'),
        )
      ],
    );
  }
}
