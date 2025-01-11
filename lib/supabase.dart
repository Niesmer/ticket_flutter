import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final String id; // Use the user's unique ID (UUID) from Supabase Auth
  final String pseudo;
  final String nom;
  final String prenom;
  final List<int>? likedIds;

  UserProfile({
    required this.id,
    required this.pseudo,
    required this.nom,
    required this.prenom,
    this.likedIds,
  });

  

  

}

class Command{
  final int id;
  final int idEvent;
  final String idUser;
  final List<String> seatNbr;

  Command({
    required this.id,
    required this.idEvent,
    required this.idUser,
    required this.seatNbr
  });

  Future<List<Command>> getCommandsByEvent(int idEvent) async {
     final data =
        await SupaConnect().client.from('Command').select().eq('id_event', id);
      return data.map((cmd) => Command.fromJson(cmd)).toList();

  }
  Future<List<Command>> getCommandsByUser(String idUser) async {
     final data =
        await SupaConnect().client.from('Command').select().eq('id_user', id);
      return data.map((cmd) => Command.fromJson(cmd)).toList();

  }

  static Future<Command> createOne(int idEvent, String idUser, List<String> seatNbr) async {
    final response = await SupaConnect().client.from('Command').insert({
      'id_user': idUser,
      'id_event' : idEvent,
      'seat_nbr': seatNbr,
    }).select();
    return Command.fromJson(response[0]);
  }


static Future<bool> seatAlreadyExists(String seatNbr, int eventId) async {
  try {
    final response = await SupaConnect().client
        .from('Command')
        .select('*')
        .eq('id_event', eventId);
   
    if (response.isEmpty) {
      return false; 
    }

    
    final List<dynamic> commands = response[0] as List;
    for (var command in commands) {
      List<String> seatNumbers = List<String>.from(command['seat_nbr']);
      if (seatNumbers.contains(seatNbr)) {
        return true; 
      }
    }

    return false; 
  } catch (e) {
    throw Exception('Error checking seat number: $e');
  }
}



  

  static Command fromJson(Map<String, dynamic> json) {
    return Command(
      id: json['id'] as int,
      idEvent: json['id_event'] as int,
      idUser: json['id_user'] as String,
seatNbr: List<String>.from(json['seat_nbr'] as List)    );
  }

}

class Event {
  final int id;
  final int price;
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
  final String createdBy; // int dans la base de données

  Event({
    required this.id,
    required this.price,
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
  });

  // Récupération de tous les événements depuis la base de données elt à envoyer : id, name, event_date, location, tickets_nbr
  static Future<List<Event>> getAll() async {
    final data = await SupaConnect().client.from('Events').select('*');
    print(data);
    return data.map((event) => Event.fromJson(event)).toList();
  }

  static Future<Event> getOne(int id) async {
    final response = await SupaConnect()
        .client
        .from('Events')
        .select()
        .eq('id', id)
        .limit(1);
    final List data = response as List; // Cast explicite en liste
    return Event.fromJson(data.first as Map<String, dynamic>);
  }

  static Future<Event> createOne(
    String name,
    int price,
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
    String createdBy,
  ) async {
    final response = await SupaConnect().client.from('Events').insert({
      'name': name,
      'price' : price,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}:00',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}:00',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket':
          '${openingTimeTicket.hour}:${openingTimeTicket.minute}:00',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket':
          '${closingTimeTicket.hour}:${closingTimeTicket.minute}:00',
      'state': 0,
      'created_by': createdBy,
    }).select();
    return Event.fromJson(response[0]);
  }

  static Future<void> deleteOne(int id) async {
    await SupaConnect().client.from('Events').delete().match({'id': id});
  }

  static Future<Event> updateOne(
    int id,
    String name,
    int price,
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
    final response = await SupaConnect().client.from('Events').update({
      'name': name,
      'price' : price,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket':
          '${openingTimeTicket.hour}:${openingTimeTicket.minute}',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket':
          '${closingTimeTicket.hour}:${closingTimeTicket.minute}',
      'state': 0,
    }).match({'id': id}).select();
    print(response);
    return Event.fromJson(response[0]);
  }

  static void updateTickets(int idEvent, int nbrTicket) async {
    await SupaConnect().client.from('Events').update({
            'tickets_nbr': nbrTicket,

    }).match({'id' : idEvent});
  }

  // Conversion d'un JSON en objet Event
  static Event fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      name: json['name'] as String,
      price : json['price'] as int,
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
        minute:
            int.parse((json['opening_time_ticket'] as String).split(':')[1]),
      ),
      closingDateTicket: DateTime.parse(json['closing_date_ticket'] as String),
      closingTimeTicket: TimeOfDay(
        hour: int.parse((json['closing_time_ticket'] as String).split(':')[0]),
        minute:
            int.parse((json['closing_time_ticket'] as String).split(':')[1]),
      ),
      state: json['state'] as int,
      createdBy: json['created_by'] as String,
    );
  }

  // Conversion d'un objet Event en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price' : price,
      'name': name,
      'event_date_start': eventDateStart.toIso8601String(),
      'event_date_end': eventDateEnd.toIso8601String(),
      'event_time_start': '${eventTimeStart.hour}:${eventTimeStart.minute}',
      'event_time_end': '${eventTimeEnd.hour}:${eventTimeEnd.minute}',
      'location': location,
      'tickets_nbr': ticketsNbr,
      'opening_date_ticket': openingDateTicket.toIso8601String(),
      'opening_time_ticket':
          '${openingTimeTicket.hour}:${openingTimeTicket.minute}',
      'closing_date_ticket': closingDateTicket.toIso8601String(),
      'closing_time_ticket':
          '${closingTimeTicket.hour}:${closingTimeTicket.minute}',
      'state': state,
      'created_by': createdBy,
    };
  }
}

class SupaConnect {
  static final SupaConnect _instance = SupaConnect._internal();
  static bool _initialized = false;

  factory SupaConnect() {
    if (_initialized) {
      return _instance;
    }
    _instance._initialize();
    _initialized = true;
    return _instance;
  }

  SupaConnect._internal();

  Future<void> _initialize() async {
    await Supabase.initialize(
      url: 'https://rhhbleufpaxszilpbkjn.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJoaGJsZXVmcGF4c3ppbHBia2puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0ODg1ODIsImV4cCI6MjA0NzA2NDU4Mn0.z8T0eHxBdavBVKNEgdTXAgv7ahOF5mxfCyA1t0Bxpls',
    );
  }

  SupabaseClient get client => Supabase.instance.client;

Future<UserProfile> getUser() async {
    var user = client.auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    final response =
        await client.from('Profiles').select().eq('id', user.id).single();

    final data = response;
    return UserProfile(
      id: data['id'],
      pseudo: data['pseudo'],
      nom: data['nom'],
      prenom: data['prenom'],
      likedIds: List<int>.from(data['likedIds'] ?? []),
    );
  } 
  Future<void> signUp(String email, String password, String pseudo, String nom,
      String prenom) async {
    try {
      // Step 1: Sign up the user with email and password
      final response = await client.auth.signUp(
          email: email,
          password: password,
          data: {'name': nom, 'firstname': prenom, 'pseudo': pseudo});

      // Ensure user is created successfully
      final user = response.user;
      if (user == null) {
        throw Exception('User creation failed');
      }
    } catch (error) {
      throw Exception('Sign-up failed: ${error.toString()}');
    }
  } 
   Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  // Sign out the current user
  Future<void> signOut() async {
    await client.auth.signOut().catchError(
        (error) => throw Exception('Sign-out failed: ${error.toString()}'));
  }

Future<List<UserProfile>> getAllUsers() async {
    final data = await SupaConnect().client.from('Profiles').select('*');
    return data.map((user) => fromJson(user)).toList();
  }

  

  static Future<UserProfile> getUserById(String id) async {
    final response =
        await SupaConnect().client.from('Profiles').select().eq('id', id).single();
            final data = response;
    return UserProfile(
      id: data['id'],
      pseudo: data['pseudo'],
      nom: data['nom'],
      prenom: data['prenom'],
      likedIds: List<int>.from(data['likedIds'] ?? []),
    );   
  }
  
 


  // Sign in an existing user
 
  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      pseudo: json['pseudo'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
      likedIds: List<int>.from(json['likedIds'] ?? []),
    );
  }

}
