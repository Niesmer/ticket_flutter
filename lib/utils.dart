import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';

String parseDate(DateTime date, TimeOfDay time) {
  final day = date.toLocal().day.toString().padLeft(2, '0');
  final month = date.toLocal().month.toString().padLeft(2, '0');
  final year = date.toLocal().year.toString();
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');

  return '$day/$month/$year - ${hour}h$minute';
}

String parseDateOnly(DateTime date) {
  final day = date.toLocal().day.toString().padLeft(2, '0');
  final month = date.toLocal().month.toString().padLeft(2, '0');
  final year = date.toLocal().year.toString();

  return '$day/$month/$year';
}

List<String>? validateDates(
    openingDateTicket,
    closingDateTicket,
    openingTimeTicket,
    closingTimeTicket,
    eventDateStart,
    eventDateEnd,
    eventTimeStart,
    eventTimeEnd) {
  final now = DateTime.now();
  final currentDate = DateTime(now.year, now.month, now.day);

  List<String> listErrors = [];

  // Vérification : Les dates doivent être dans le futur
  if (openingDateTicket != null && openingDateTicket!.isBefore(currentDate)) {
    listErrors
        .add('La date d\'ouverture doit être aujourd\'hui ou dans le futur.');
  }
  if (closingDateTicket != null && closingDateTicket!.isBefore(currentDate)) {
    listErrors
        .add('La date de fermeture doit être aujourd\'hui ou dans le futur.');
  }
  if (eventDateStart != null && eventDateStart!.isBefore(currentDate)) {
    listErrors.add(
        'La date de début d\'événement doit être aujourd\'hui ou dans le futur.');
  }

  if (eventDateStart != null &&
      openingDateTicket != null &&
      eventDateStart!.isBefore(openingDateTicket)) {
    listErrors
        .add('La billetterie doit ouvrir maximum 1 jour avant l\'événement');
  }
  if (eventDateEnd != null &&
      closingDateTicket != null &&
      (eventDateEnd!.isBefore(closingDateTicket) ||
          (eventDateEnd == closingDateTicket &&
              (eventTimeEnd!.hour < closingTimeTicket!.hour ||
                  (eventTimeEnd!.hour == closingTimeTicket!.hour &&
                      eventTimeEnd!.minute <= closingTimeTicket!.minute))))) {
    listErrors
        .add('La billetterie doit être fermée après la fin de l\'événement.');
  }

  // Vérification : Ouverture avant fermeture
  if (openingDateTicket != null &&
      closingDateTicket != null &&
      openingDateTicket!.isAfter(closingDateTicket!)) {
    listErrors.add(
        'La date d\'ouverture de la billetterie doit être antérieure ou égale à la date de fermeture.');
  }

  // Vérification : Heures (si dates égales)
  if (openingDateTicket != null &&
      closingDateTicket != null &&
      openingDateTicket == closingDateTicket) {
    if (openingTimeTicket != null &&
        closingTimeTicket != null &&
        (openingTimeTicket!.hour > closingTimeTicket!.hour ||
            (openingTimeTicket!.hour == closingTimeTicket!.hour &&
                openingTimeTicket!.minute >= closingTimeTicket!.minute))) {
      listErrors.add(
          'L\'heure d\'ouverture de la billetterie doit être avant l\'heure de fermeture.');
    }
  }

  // Vérification : Début avant fin
  if (eventDateStart != null &&
      eventDateEnd != null &&
      eventDateStart!.isAfter(eventDateEnd!)) {
    listErrors
        .add('La date de début doit être avant ou égale à la date de fin.');
  }

  if (eventDateStart != null &&
      eventDateEnd != null &&
      eventDateStart == eventDateEnd) {
    if (eventTimeStart != null &&
        eventTimeEnd != null &&
        (eventTimeStart!.hour > eventTimeEnd!.hour ||
            (eventTimeStart!.hour == eventTimeEnd!.hour &&
                eventTimeStart!.minute >= eventTimeEnd!.minute))) {
      listErrors.add(
          'L\'heure d\'ouverture de l\'évenement doit être avant l\'heure de fermeture.');
    }
  }

  return listErrors; // Aucune erreur
}

Future<List<String>> getSeatNumbers(int nbrTickets, int eventId) async {
  List<String> seats = [];
  Random random = Random();
  const String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const int maxNumber = 150;

  while (seats.length < nbrTickets) {
    // Generate a random seat number (e.g., "A23")
    String letter = alphabet[random.nextInt(alphabet.length)];
    int number = random.nextInt(maxNumber) + 1;
    String seatNbr = '$letter$number';

    // Check if the generated seat number already exists
    bool exists = await Command.seatAlreadyExists(seatNbr, eventId);
    if (!exists) {
      seats.add(seatNbr);
    }
  }
  print(seats);
  return seats;
}
