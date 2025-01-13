import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class UserProfile {
  final String id; // Use the user's unique ID (UUID) from Supabase Auth
  final String pseudo;
  final String nom;
  final String prenom;
  final int role;
  final List<int>? likedIds;
  final String email;

  UserProfile({
    required this.id,
    required this.pseudo,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.email,
    this.likedIds,
  });

  bool get isAdmin {
    return role == 1;
  }
}

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
  final String createdBy; // int dans la base de données

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
    final data = await SupaConnect().client.from('Events').select('*');
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
    print('oui');
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
  static Completer<void>? _initializerCompleter;

  SupabaseClient? _client;

  factory SupaConnect() {
    return _instance;
  }

  SupaConnect._internal();

  Future<void> _initialize() async {
    await Supabase.initialize(
      url: 'https://rhhbleufpaxszilpbkjn.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJoaGJsZXVmcGF4c3ppbHBia2puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0ODg1ODIsImV4cCI6MjA0NzA2NDU4Mn0.z8T0eHxBdavBVKNEgdTXAgv7ahOF5mxfCyA1t0Bxpls',
    );
    _client = Supabase.instance.client;
  }

  static Future<void> ensureInitialized() async {
    if (_initializerCompleter == null) {
      _initializerCompleter = Completer<void>();
      _instance._initialize().then((_) {
        _initializerCompleter?.complete();
      }).catchError((error) {
        _initializerCompleter?.completeError(error);
      });
    }
    await _initializerCompleter?.future;
  }

  SupabaseClient get client {
    if (_client == null) {
      throw Exception(
          'SupaConnect not initialized. Call SupaConnect.ensureInitialized().');
    }
    return _client!;
  }

  Future<void> signUp(String email, String password, String pseudo, String nom,
      String prenom) async {
    await SupaConnect.ensureInitialized();
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {'name': nom, 'firstname': prenom, 'pseudo': pseudo},
      );

      final user = response.user;
      if (user == null) {
        throw Exception('User creation failed');
      }
    } catch (error) {
      throw Exception('Sign-up failed: ${error.toString()}');
    }
  }

  Future<UserProfile?> getUser() async {
    await SupaConnect.ensureInitialized();
    var user = client.auth.currentUser;
    if (user == null) {
      return null;
    }

    final response =
        await client.from('Profiles').select().eq('id', user.id).single();

    final data = response;
    return UserProfile(
      id: data['id'],
      pseudo: data['pseudo'],
      nom: data['nom'],
      prenom: data['prenom'],
      role: data['role'],
      likedIds: List<int>.from(data['likedIds'] ?? []),
      email: user.email ?? '',
    );
  }

  Future<UserProfile?> signIn(String email, String password) async {
    await SupaConnect.ensureInitialized();
    AuthResponse rep =
        await client.auth.signInWithPassword(email: email, password: password);
    if (rep.user == null) {
      return null;
    }

    return await getUser();
  }

  Future<void> signOut() async {
    await SupaConnect.ensureInitialized();
    await client.auth.signOut().catchError(
        (error) => throw Exception('Sign-out failed: ${error.toString()}'));
  }
}
