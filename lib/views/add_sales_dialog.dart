import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/vehicle.dart';
import '../controllers/client.dart';

class AddSaleDialog extends StatefulWidget {
  final void Function(Vehicle vehicle, Client client, DateTime date, String paymentType) onAddSale;
  final List<Vehicle> availableVehicles;
  final List<Client> availableClients;
  final Vehicle? initialVehicle;
  final Client? initialClient;
  final DateTime? initialDate;
  final String? initialPaymentType;

  const AddSaleDialog({
    super.key,
    required this.onAddSale,
    required this.availableVehicles,
    required this.availableClients,
    this.initialVehicle,
    this.initialClient,
    this.initialDate,
    this.initialPaymentType,
  });

  @override
  State<AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<AddSaleDialog> {
  late Vehicle? selectedVehicle;
  late Client? selectedClient;
  late TextEditingController dateController;
  late String paymentType;

  @override
  void initState() {
    super.initState();
    selectedVehicle = widget.initialVehicle;
    selectedClient = widget.initialClient;
    dateController = TextEditingController(
      text: widget.initialDate != null
          ? DateFormat('yyyy-MM-dd').format(widget.initialDate!)
          : '',
    );
    paymentType = widget.initialPaymentType ?? 'Efectivo';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialVehicle == null ? 'Agregar Venta' : 'Editar Venta'),
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
                  child: Text(vehicle.name),
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
                    dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
            if (selectedVehicle != null &&
                selectedClient != null &&
                dateController.text.isNotEmpty) {
              widget.onAddSale(
                selectedVehicle!,
                selectedClient!,
                DateTime.parse(dateController.text),
                paymentType,
              );
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor, completa todos los campos')),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
