import 'package:flutter/material.dart';
import 'package:ticket_flutter/views/eventListPage.dart';
import 'package:ticket_flutter/utils.dart';
import 'event.dart';
import 'supabaseConnection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des événements',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EventListPage(),
    );
  }
}



