import 'package:flutter/material.dart';
import 'package:ticket_flutter/global.dart';
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
    _futureEvents = Event.getEventsByUser(currentUser!.id);
  }

   void _refreshEvents() {
    setState(() {
      _futureEvents = Event.getEventsByUser(currentUser!.id); // Refresh event list
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 157, 192, 249),
          appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 157, 192, 249),
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                title: Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Text('LISTE DES ÉVÉNEMENTS',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 2, 78, 218),
                        fontWeight: FontWeight.w800)),
              )),
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
             return Padding(
                    padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventListRow(
                  event: events[index],
                  onEventChanged: _refreshEvents, // Callback to refresh list
                );
              },
             ));
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
        backgroundColor: Color.fromARGB(255, 2, 78, 218),
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    ));
  }

  
}