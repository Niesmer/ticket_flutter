import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabaseConnection.dart';

class Event {
 final int id;
  final String name;
  final DateTime eventDateStart;
  final DateTime eventDateEnd;
  final TimeOfDay eventTimeStart;
  final TimeOfDay eventTimeEnd;
  final String location;
  final int ticketsNbr;
  final DateTime openingDateTicket;
  final TimeOfDay openingTimeTicket;
  final DateTime closingDateTicket;
  final TimeOfDay closingTimeTicket;
  final int? state;
  final List<int>? likedIds;
  final int createdBy; // int dans la base de données

  Event({
    required this.id,
    required this.name,
    required this.eventDateStart,
    required this.eventDateEnd,
    required this.eventTimeStart,
    required this.eventTimeEnd,
    required this.location,
    required this.ticketsNbr,
    required this.openingDateTicket,
    required this.openingTimeTicket,
    required this.closingDateTicket,
    required this.closingTimeTicket,
    required this.createdBy,
    this.state,
    this.likedIds,
    
    
  });

  // Récupération de tous les événements depuis la base de données elt à envoyer : id, name, event_date, location, tickets_nbr
  static Future<List<Event>> getAll() async {
    final data = await supabase.from('Events').select('*');
    print(data);
    return data.map((event) => Event.fromJson(event)).toList();
  }

  static Future<Event> getOne(int id) async {
    final response =
        await supabase.from('Events').select().eq('id', id).limit(1);
  final List data = response as List; // Cast explicite en liste
  return Event.fromJson(data.first as Map<String, dynamic>);
  }

  static Future<Event> createOne(
       String name,
     DateTime eventDateStart,
     DateTime eventDateEnd,
     TimeOfDay eventTimeStart,
     TimeOfDay eventTimeEnd,
     String location,
     int ticketsNbr,
     DateTime openingDateTicket,
     TimeOfDay openingTimeTicket,
     DateTime closingDateTicket,
     TimeOfDay closingTimeTicket,
     int createdBy,) async {
    final response = await supabase.from('Events').insert({
      'name': name,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}:00',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}:00',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket': '${openingTimeTicket.hour}:${openingTimeTicket.minute}:00',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket': '${closingTimeTicket.hour}:${closingTimeTicket.minute}:00',
      'state': 0,
      'user_liking_ids': [],
      'created_by': createdBy,
    }).select();
    return Event.fromJson(response[0]);
  }

  static Future<void> deleteOne(int id) async {
    await supabase.from('Events').delete().match({'id': id});
    
  }

  

  static Future<Event> updateOne(
      int id,
      String name,
     DateTime eventDateStart,
     DateTime eventDateEnd,
     TimeOfDay eventTimeStart,
     TimeOfDay eventTimeEnd,
     String location,
     int ticketsNbr,
     DateTime openingDateTicket,
     TimeOfDay openingTimeTicket,
     DateTime closingDateTicket,
     TimeOfDay closingTimeTicket,
     ) async {
        final response = await supabase.from('Events').update({
     'name': name,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket': '${openingTimeTicket.hour}:${openingTimeTicket.minute}',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket': '${closingTimeTicket.hour}:${closingTimeTicket.minute}',
      'state': 0,
      'user_liking_ids': []}).match({'id': id}).select();
      print(response);
      return Event.fromJson(response[0]);

      }


  // Conversion d'un JSON en objet Event
  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      eventDateStart: DateTime.parse(json['event_date_start'] as String),
      eventDateEnd: DateTime.parse(json['event_date_end'] as String),
      eventTimeStart: TimeOfDay(
        hour: int.parse((json['event_time_start'] as String).split(':')[0]),
        minute: int.parse((json['event_time_start'] as String).split(':')[1]),
      ),
      eventTimeEnd: TimeOfDay(
        hour: int.parse((json['event_time_end'] as String).split(':')[0]),
        minute: int.parse((json['event_time_end'] as String).split(':')[1]),
      ),
      location: json['location'] as String,
      ticketsNbr: json['tickets_nbr'] as int,
      openingDateTicket: DateTime.parse(json['opening_date_ticket'] as String),
      openingTimeTicket: TimeOfDay(
        hour: int.parse((json['opening_time_ticket'] as String).split(':')[0]),
        minute: int.parse((json['opening_time_ticket'] as String).split(':')[1]),
      ),
      closingDateTicket: DateTime.parse(json['closing_date_ticket'] as String),
      closingTimeTicket: TimeOfDay(
        hour: int.parse((json['closing_time_ticket'] as String).split(':')[0]),
        minute: int.parse((json['closing_time_ticket'] as String).split(':')[1]),
      ),
      state: json['state'] as int,
      likedIds:
            List<int>.from(json['user_liking_ids'] ?? []), 
      createdBy: json['created_by'] as int,
    );
  }

  // Conversion d'un objet Event en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket': '${openingTimeTicket.hour}:${openingTimeTicket.minute}',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket': '${closingTimeTicket.hour}:${closingTimeTicket.minute}',
      'state': state,
      'user_liking_ids': likedIds,
      'created_by': createdBy,
    };
  }
}
