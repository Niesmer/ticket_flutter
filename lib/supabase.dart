import 'package:supabase_flutter/supabase_flutter.dart';

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

  // Sign up a new user
  Future<void> signUp(String email, String password, String pseudo, String nom,
      String prenom) async {
    try {
      // Step 1: Sign up the user with email and password
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      // Ensure user is created successfully
      final user = response.user;
      final session = response.session;

      print(session);
      print(user);
      if (user == null) {
        throw Exception('User creation failed');
      }

      // Step 2: Add user profile to the profiles table
      await client.from('Profiles').insert({
        'id': user.id, // Use the user ID from Supabase Auth
        'pseudo': pseudo,
        'nom': nom,
        'prenom': prenom,
        'liked_events_id': [], // Default value for likedIds
        'role': 0, // Default value for role
      });
    } catch (error) {
      throw Exception('Sign-up failed: ${error.toString()}');
    }
  }

  Future<UserProfile> getUser() async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('No user signed in');
    }

    final response =
        await client.from('profiles').select().eq('id', user.id).single();

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
  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  // Sign out the current user
  Future<void> signOut() async {
    await client.auth.signOut().catchError(
        (error) => throw Exception('Sign-out failed: ${error.toString()}'));
  }
}
