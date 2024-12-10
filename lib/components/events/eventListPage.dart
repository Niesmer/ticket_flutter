import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import './eventForm.dart';
import './eventListRow.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
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
                return EventListRow(
                  event: events[index],
                  onEventChanged: _refreshEvents, // Callback to refresh list
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await showDialog(
            context: context,
            builder: (context) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EventForm(),
      ),
            ),
          );
          if (added == true) _refreshEvents(); // Refresh if event was added
        },
        tooltip: 'Ajouter un événement',
        child: Icon(Icons.add),
      ),
    );
  }

  
}
