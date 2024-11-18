import 'package:flutter/material.dart';
import 'package:ticket_flutter/event.dart';
import 'package:ticket_flutter/supabaseConnection.dart';
import 'eventListPage.dart'; // Assurez-vous que ce fichier est correctement référencé

void main() {
  initialize();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(), // Démarre l'application sur la page des événements
    );
  }
}
