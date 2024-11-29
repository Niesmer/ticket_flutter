import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabaseConnection.dart';

import 'event.dart'; // Assurez-vous que la classe Event est importée

void main() async {
  initialize();
  WidgetsFlutterBinding.ensureInitialized(); // Assure l'initialisation correcte de Flutter
  print('Tests de la classe Event en cours...');

  // Appeler les fonctions de test ici
  await testUpdateOne();
}

/// Tester getOne
Future<void> testGetOne() async {
  try {
    final event = await Event.getOne(2); // ID de test
    print('Résultat de getOne : ${event.toJson()}');
  } catch (e) {
    print('Erreur dans getOne : $e');
  }
}

/// Tester createOne
Future<void> testCreateOne() async {
  try {
    final newEvent = await Event.createOne(
      'Evt',
      DateTime.parse('2024-01-15'),
      'Paris',
      100,
      DateTime.parse('2024-01-01'),
      DateTime.parse('2024-01-10'),
      1, // CreatedBy ID de test
    );
    print('Résultat de createOne : ${newEvent}');
  } catch (e) {
    print('Erreur dans createOne : $e');
  }
}

/// Tester deleteOne
Future<void> testDeleteOne() async {
  try {
    await Event.deleteOne(12); // ID de test à supprimer
    print('Événement supprimé avec succès.');
  } catch (e) {
    print('Erreur dans deleteOne : $e');
  }
}

/// Tester updateOne
Future<void> testUpdateOne() async {
  try {
    final updatedEvent = await Event.updateOne(
      14, // ID de test
      'Événement mis à jour',
      DateTime.parse('2024-02-01'),
      'Lyon',
      150,
      DateTime.parse('2024-01-20'),
      DateTime.parse('2024-01-30'),
      1, // Nouvel état
    );
    print('Résultat de updateOne : ${updatedEvent}');
  } catch (e) {
    print('Erreur dans updateOne : $e');
  }
}
