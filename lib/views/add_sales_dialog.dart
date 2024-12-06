import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/vehicle.dart';
import '../controllers/client.dart';

class AddSaleDialog extends StatefulWidget {
  final void Function(Vehicle vehicle, Client client, DateTime date,
      String paymentType, double price) onAddSale;
  final List<Vehicle> availableVehicles;
  final List<Client> availableClients;
  final Vehicle? initialVehicle;
  final Client? initialClient;
  final DateTime? initialDate;
  final String? initialPaymentType;
  final double? initialPrice;

  const AddSaleDialog({
    super.key,
    required this.onAddSale,
    required this.availableVehicles,
    required this.availableClients,
    this.initialVehicle,
    this.initialClient,
    this.initialDate,
    this.initialPaymentType,
    this.initialPrice,
  });

  @override
  State<AddSaleDialog> createState() => _AddSaleDialogState();
}

class _AddSaleDialogState extends State<AddSaleDialog> {
  late Vehicle? selectedVehicle;
  late Client? selectedClient;
  late TextEditingController dateController;
  late String paymentType;
  late TextEditingController priceController;

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
    priceController = TextEditingController(
      text: widget.initialPrice != null
          ? widget.initialPrice!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          widget.initialVehicle == null ? 'Agregar Venta' : 'Agregar Venta'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            selectedVehicle != null
                ? Text(
                    'Vehículo: ${selectedVehicle!.name} (${selectedVehicle!.model})',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  )
                : const Text(
                    'No se ha seleccionado ningún vehículo.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Precio'),
              onChanged: (value) {
                setState(() {});
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
                dateController.text.isNotEmpty &&
                priceController.text.isNotEmpty) {
              final price = double.tryParse(priceController.text);
              final saleData = {
                'vehicle': selectedVehicle,
                'client': selectedClient,
                'date': DateTime.parse(dateController.text),
                'paymentType': paymentType,
                'price': price,
              };
              
              if (price != null && price > 0) {
                widget.onAddSale(
                  selectedVehicle!,
                  selectedClient!,
                  DateTime.parse(dateController.text),
                  paymentType,
                  price,
                );
                Navigator.of(context).pop(saleData);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Por favor, ingresa un precio válido')),
                );
              }
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
