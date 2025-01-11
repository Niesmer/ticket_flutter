import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import 'eventListRowClient.dart';

class EventListPageClient extends StatefulWidget {
  const EventListPageClient({super.key});

  @override
  _EventListPageClientState createState() => _EventListPageClientState();
}

class _EventListPageClientState extends State<EventListPageClient> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = Event.getAll();
  }

   void _refreshEvents() {
    setState(() {
      _futureEvents = Event.getAll(); // Refresh event list
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des événements'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun événement trouvé.'));
          } else {
            final events = snapshot.data!;
             return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventListRowClient(
                  event: events[index],
                  onEventChanged: _refreshEvents, // Callback to refresh list
                );
              },
            );
          }
        },
      ),
    );
  }

  
}
