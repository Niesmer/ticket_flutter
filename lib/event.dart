import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabaseConnection.dart';

class Event {
  final int id;
  final DateTime createdAt;         // timestamp dans la base de données
  final DateTime eventDate;          // date dans la base de données
  final String location;             // varchar dans la base de données
  final int ticketsNbr;              // int4 dans la base de données
  final DateTime openingDateTicket;  // date dans la base de données
  final DateTime closingDateTicket;  // date dans la base de données
  final int? state;                   // int dans la base de données
  final List<int>? likedIds;          // int8[] dans la base de données
  final int? createdBy;               // int dans la base de données

  Event({
    required this.id,
    required this.createdAt,
    required this.eventDate,
    required this.location,
    required this.ticketsNbr,
    required this.openingDateTicket,
    required this.closingDateTicket,
     this.state,
     this.likedIds,
     this.createdBy,
  });

  // Récupération de tous les événements depuis la base de données
  static Future<List<Event>> getAll() async {
    final data = await Supabase.instance.client.from('Events').select();
    

    return data.map((event) => Event.fromJson(event)).toList();

  }

  // Conversion d'un JSON en objet Event
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        eventDate: DateTime.parse(json['event_date'] as String),
        location: json['location'] as String,
        ticketsNbr: json['tickets_nbr'] as int,
        openingDateTicket: DateTime.parse(json['opening_date_ticket'] as String),
        closingDateTicket: DateTime.parse(json['closing_date_ticket'] as String),
        state: json['state'] as int?,
        likedIds: List<int>.from(json['liked_ids'] ?? []), // Gère un tableau vide
        createdBy: json['created_by'] as int?,
      );

  // Conversion d'un objet Event en JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'event_date': eventDate.toIso8601String(),
        'location': location,
        'tickets_nbr': ticketsNbr,
        'opening_date_ticket': openingDateTicket.toIso8601String(),
        'closing_date_ticket': closingDateTicket.toIso8601String(),
        'state': state,
        'liked_ids': likedIds,
        'created_by': createdBy,
      };
}
