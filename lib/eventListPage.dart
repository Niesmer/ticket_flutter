import 'package:flutter/material.dart';
import 'supabaseConnection.dart'; // Assurez-vous que ce fichier contient la configuration de Supabase
import 'event.dart';             // Importez le modèle Event avec la fonction getAll



class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}


class _EventListPageState extends State<EventListPage> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = Event.getAll(); // Charge les événements dès le chargement de la page
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
            return Center(child: CircularProgressIndicator()); // Indicateur de chargement
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}')); // Affiche l'erreur si elle survient
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun événement trouvé')); // Message si aucun événement n'est trouvé
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.location),
                  subtitle: Text(
                    'Date: ${event.eventDate.toLocal()} \n'
                    'Tickets: ${event.ticketsNbr} \n'
                  ),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
