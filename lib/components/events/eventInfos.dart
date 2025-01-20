import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/commandListAdmin.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:ticket_flutter/utils.dart';
import './eventForm.dart';

class EventInfos extends StatefulWidget {
  final int eventId;
  final VoidCallback onEventChanged;

  const EventInfos({
    super.key,
    required this.eventId,
    required this.onEventChanged,
  });

  @override
  _EventInfosState createState() => _EventInfosState();
}

class _EventInfosState extends State<EventInfos> {
  late Future<Event> _eventFuture;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  void _loadEvent() {
    setState(() {
      _eventFuture = Event.getOne(widget.eventId);
    });
  }

  Future<void> _seeComands() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommandListAdmin(eventId: widget.eventId),
      ),
    );

    if (result == true) {
      widget
          .onEventChanged(); // Notifie le parent que des modifications ont été faites
      _loadEvent();
    }
  }

  Future<void> _onEditEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventForm(eventId: widget.eventId),
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
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _seeComands,
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Voir les commandes'),
                      ),
                      ElevatedButton.icon(
                        onPressed: _onEditEvent,
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            textStyle: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          final confirm =
                              await _showConfirmationDialog(context);
                          if (confirm == true) {
                            await Event.deleteOne(widget.eventId);
                            widget
                                .onEventChanged(); // Notifie le parent d'un changement
                            Navigator.pop(context, true); // Retourne à la liste
                          }
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Supprimer'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cet événement ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
