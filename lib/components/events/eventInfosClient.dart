import 'package:flutter/material.dart';
import 'package:ticket_flutter/global.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:ticket_flutter/utils.dart';
import './command.dart';

class EventInfosClient extends StatefulWidget {
  final int eventId;
  final VoidCallback onEventChanged;

  const EventInfosClient({
    super.key,
    required this.eventId,
    required this.onEventChanged,
  });

  @override
  _EventInfosClientState createState() => _EventInfosClientState();
}

class _EventInfosClientState extends State<EventInfosClient> {
  late Future<Event> _eventFuture;
  late UserProfile? _user;
  String? errorMessage;


  @override
  void initState() {
    super.initState();
    _loadEvent();
    _user = currentUser;
  }

  void _loadEvent() {
    setState(() {
      _eventFuture = Event.getOne(widget.eventId);
    });
  }

  Future<void> _onCommand() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommandPage(eventId: widget.eventId, user: _user),
      ),
    );

    if (result == true) {
      widget
          .onEventChanged(); // Notifie le parent que des modifications ont été faites
      _loadEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'événement'),
      ),
      body: FutureBuilder<Event>(
        future: _eventFuture,
        builder: (BuildContext context, AsyncSnapshot<Event> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucun événement trouvé.'));
          } else {
            final event = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Text('Lieu : ${event.location}'),
                  const SizedBox(height: 8),
                  Text(
                    'Début : ${parseDate(event.eventDateStart, event.eventTimeStart)}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fin :  ${parseDate(event.eventDateEnd, event.eventTimeEnd)}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Billets disponibles : ${event.ticketsNbr}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Prix : ${event.price}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ouverture Billeterie : ${parseDate(event.openingDateTicket, event.openingTimeTicket)}',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fermeture Billeterie :  ${parseDate(event.closingDateTicket, event.closingTimeTicket)}',
                  ),
                  const SizedBox(height: 16),
                   if (!validateTicketOpening(event.openingDateTicket,event.openingTimeTicket)) ...[
                  const Text(
                    "La billeterie n'est pas encore ouverte."
                  ),
                   ]
                  else if (!validateTicketClosing(event.closingDateTicket,event.closingTimeTicket)) ...[
                  const Text(
                    "La billeterie est fermée"
                  ),
                ] else if (event.ticketsNbr <= 0) ...[
                  const Text(
                    "Il n'y a plus de tickets disponibles.",
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _onCommand,
                        icon: const Icon(Icons.edit),
                        label: const Text('Commander'),
                      ),
                    ],
                  ),
                ],
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
