import 'package:flutter/material.dart';
import 'package:ticket_flutter/event.dart';

class EventInfos extends StatelessWidget {
  final int eventId;

  const EventInfos({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    late Future<Event> event = Event.getOne(eventId);
    return Scaffold(
      appBar: AppBar(title: Text('Détails de l\'événement #$eventId')),
      body: Center(child: Text('Infos détaillées pour l\'événement $eventId')),
    );
  }
}
