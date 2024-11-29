import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabaseConnection.dart';

class Event {
  final int id;
  final String name;
  final DateTime createdAt; // timestamp dans la base de données
  final DateTime eventDate; // date dans la base de données
  final String location; // varchar dans la base de données
  final int ticketsNbr; // int4 dans la base de données
  final DateTime openingDateTicket; // date dans la base de données
  final DateTime closingDateTicket; // date dans la base de données
  final int? state; // int dans la base de données
  final List<int>? userLikingIds; // int8[] dans la base de données
  final int? createdBy; // int dans la base de données

  Event({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.eventDate,
    required this.location,
    required this.ticketsNbr,
    required this.openingDateTicket,
    required this.closingDateTicket,
    required this.createdBy,
    this.state,
    this.userLikingIds,
    
  });

  // Récupération de tous les événements depuis la base de données
  static Future<List<Event>> getAll() async {
    final data = await Supabase.instance.client.from('Events').select('id, name, eventDate, location');
    return data.map((event) => Event.fromJson(event)).toList();
  }

  static Future<Event> getOne(int id) async {
    final response =
        await Supabase.instance.client.from('Events').select().eq('id', id).limit(1);
  final List data = response as List; // Cast explicite en liste
  return Event.fromJson(data.first as Map<String, dynamic>);
  }

  static Future<Event> createOne(
      String name,
      DateTime eventDate,
      String location,
      int ticketsNbr,
      DateTime openingDateTicket,
      DateTime closingDateTicket,
      int createdBy) async {
    final response = await supabase.from('Events').insert({
      'name' : name,
      'event_date': eventDate.toIso8601String(),
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'state': 0,
      'created_by': createdBy
    }).select();
    return Event.fromJson(response[0]);
  }

  static Future<void> deleteOne(int id) async {
    await supabase.from('Events').delete().match({'id': id});
    
  }

  static void addLike(int idUser, int idEvent){

  }

  static Future<Event> updateOne(
      int id,
      String name,
      DateTime eventDate,
      String location,
      int ticketsNbr,
      DateTime openingDateTicket,
      DateTime closingDateTicket, 
      int state) async {
        final response = await supabase.from('Events').update({
      'name' : name,
      'event_date': eventDate.toIso8601String(),
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'state': state}).match({'id': id}).select();
      print(response);
      return Event.fromJson(response[0]);

      }


  // Conversion d'un JSON en objet Event
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'] as int,
        name : json['name'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        eventDate: DateTime.parse(json['event_date'] as String),
        location: json['location'] as String,
        ticketsNbr: json['tickets_nbr'] as int,
        openingDateTicket:
            DateTime.parse(json['opening_date_ticket'] as String),
        closingDateTicket:
            DateTime.parse(json['closing_date_ticket'] as String),
        state: json['state'] as int?,
        userLikingIds:
            List<int>.from(json['user_liking_ids'] ?? []), // Gère un tableau vide
        createdBy: json['created_by'] as int?,
      );

  // Conversion d'un objet Event en JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name' : name,
        'created_at': createdAt.toIso8601String(),
        'event_date': eventDate.toIso8601String(),
        'location': location,
        'tickets_nbr': ticketsNbr,
        'opening_date_ticket': openingDateTicket.toIso8601String(),
        'closing_date_ticket': closingDateTicket.toIso8601String(),
        'state': state,
        'user_liking_ids': userLikingIds,
        'created_by': createdBy,
      };
}
