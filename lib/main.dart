import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyecto_integrador/controllers/appointment.dart';
import 'package:proyecto_integrador/controllers/sales.dart';
import 'controllers/vehicle.dart';
import 'controllers/client.dart';
import 'views/sales_screen.dart';
import 'views/inventory_screen.dart';
import 'views/clients_screen.dart';
import 'views/appointments_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VehicleAdapter());
  Hive.registerAdapter(ClientAdapter());
  Hive.registerAdapter(AppointmentAdapter());
  Hive.registerAdapter(SalesAdapter());

  await Hive.openBox<Vehicle>('inventario');
  await Hive.openBox<Client>('clientes');
  await Hive.openBox<Appointment>('appointments');
  await Hive.openBox<Sales>('ventas');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;

    final lightTheme = ThemeData.light().copyWith(
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        titleLarge: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.deepPurple),
    );

    final darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/sales': (context) => const SalesScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/clients': (context) => const ClientsScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
      },
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode:
          brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final paddingTop = mediaQuery.padding.top;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + paddingTop),
        child: AppBar(
          title: const Text('AGENCIA DE AUTOS\nCARLOS ANTONIO'),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: false,
          toolbarHeight: kToolbarHeight + paddingTop,
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Por favor, seleccione una opción que quiera consultar',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildOption(
                  icon: Icons.directions_car,
                  label: 'INVENTARIO',
                  route: '/inventory',
                  context: context,
                ),
                _buildOption(
                  icon: Icons.calendar_today,
                  label: 'CITAS',
                  route: '/appointments',
                  context: context,
                ),
                _buildOption(
                  icon: Icons.people,
                  label: 'CLIENTES',
                  route: '/clients',
                  context: context,
                ),
                _buildOption(
                  icon: Icons.handshake,
                  label: 'VENTAS',
                  route: '/sales',
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
      {required IconData icon,
      required String label,
      required String route,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
