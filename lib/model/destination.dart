import 'package:flutter/material.dart';

class Destination {
  const Destination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

final List<Destination> destinations = [
  Destination(label: "Acceuil", icon: Icons.home),
  Destination(label: "Mes commandes", icon: Icons.list_alt),
  Destination(label: "Profil", icon: Icons.person)
];

final List<Destination> destinationsAdmin = [
  Destination(label: "Acceuil", icon: Icons.home),
  Destination(label: "Mes commandes", icon: Icons.list_alt),
  Destination(label: "Admin Event", icon: Icons.event),
  Destination(label: "Profil", icon: Icons.person),
];