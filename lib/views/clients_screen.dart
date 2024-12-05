import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/client.dart';
import 'add_client_dialog.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  ClientsScreenState createState() => ClientsScreenState();
}

class ClientsScreenState extends State<ClientsScreen> {
  late Box<Client> clientBox;

  @override
  void initState() {
    super.initState();
    clientBox = Hive.box<Client>('clientes');
  }

  void _addClient(String name, String email, String phone) {
    final newClient = Client(
      clientId: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
    );
    clientBox.add(newClient);
  }

  void _editClient(int index, String name, String email, String phone) {
    final updatedClient = Client(
      name: name,
      email: email,
      phone: phone,
      clientId: '',
    );
    clientBox.putAt(index, updatedClient);
  }

  void _deleteClient(int index) {
    clientBox.deleteAt(index);
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Estás seguro de que deseas eliminar a ${clientBox.getAt(index)?.name}? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _deleteClient(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddClientDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddClientDialog(onAddClient: (name, email, phone) {
          _addClient(name, email, phone);
          Navigator.of(context).pop();
        });
      },
    );
  }

  void _showEditClientDialog(int index) {
    final client = clientBox.getAt(index);
    final TextEditingController nameController =
        TextEditingController(text: client?.name);
    final TextEditingController emailController =
        TextEditingController(text: client?.email);
    final TextEditingController phoneController =
        TextEditingController(text: client?.phone);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Cliente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: emailController,
                decoration:
                    const InputDecoration(labelText: 'Correo Electrónico'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                _editClient(
                  index,
                  nameController.text,
                  emailController.text,
                  phoneController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ValueListenableBuilder(
        valueListenable: clientBox.listenable(),
        builder: (context, Box<Client> box, _) {
          final clients = box.values.toList();

          return clients.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay ningún cliente',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Presione el botón para agregar un cliente',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: clients.length,
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(client.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(client.email),
                          Text('Teléfono: ${client.phone}'),
                        ],
                      ),
                      onTap: () {
                        _showEditClientDialog(index);
                      },
                      onLongPress: () {
                        _showDeleteConfirmationDialog(index);
                      },
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClientDialog,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
