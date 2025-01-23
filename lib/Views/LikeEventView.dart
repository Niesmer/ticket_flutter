import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/eventLikedList.dart';
import 'package:ticket_flutter/login_signup.dart';
import 'package:ticket_flutter/supabase.dart';

class LikedEventView extends StatelessWidget {
  late Future<List<Event>> likedEvents;

  LikedEventView({super.key}) {
    likedEvents = Event.getLikedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 157, 192, 249),
      body: FutureBuilder<List<Event>>(
        future: likedEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No liked events found.'));
          } else {
            return Eventlikedlist(events: snapshot.data!);
          }
        },
      ),
    );
  }
}
