import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import 'eventListRowClient.dart';

class Eventlikedlist extends StatefulWidget {
  const Eventlikedlist({super.key});

  @override
  _EventlikedlistState createState() => _EventlikedlistState();
}

class _EventlikedlistState extends State<Eventlikedlist> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = Event.getLikedEvents();
  }

   void _refreshEvents() {
    setState(() {
      _futureEvents = Event.getLikedEvents(); // Refresh event list
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
                if (events[index].state == 0){
                  return EventListRowClient(
                  event: events[index],
                  onEventChanged: _refreshEvents, // Callback to refresh list
                );
                }
                return null;
                
              },
            );
          }
        },
      ),
    );
  }

  
}
