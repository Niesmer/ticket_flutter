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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [ Text(
                    event.name,
                     style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 2, 78, 218),
                        fontWeight: FontWeight.w800)),],
                  ),
                 
              
                  

                  Padding(
                    padding: EdgeInsets.all(8),
                    child:
                  Text('Lieu : ${event.location}')),
                  Padding(
                  
                  
                    padding: EdgeInsets.all(8),
                    child:Text(  'Début : ${parseDate(event.eventDateStart, event.eventTimeStart)}',
                  )),
                   Padding(
                  
                 
                    padding: EdgeInsets.all(8),
                    child: Text( 'Fin :  ${parseDate(event.eventDateEnd, event.eventTimeEnd)}',
                  )),
                  
                  
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text( 'Billets disponibles : ${event.ticketsNbr}',
                  )),
                  
                  
                  Padding(
                    padding: EdgeInsets.all(8),
                    child:Text(  'Prix : ${event.price} €',
                  )),
                  
                  
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text( 'Ouverture Billeterie : ${parseDate(event.openingDateTicket, event.openingTimeTicket)}',
                  )),
                  
                  Padding(
                    padding: EdgeInsets.all(8),
                    child:Text(
                    'Fermeture Billeterie :  ${parseDate(event.closingDateTicket, event.closingTimeTicket)}',
                  )),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                padding: EdgeInsets.all(5.0),
                child: (
                      ElevatedButton.icon(
                        onPressed: _seeComands,
                        style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 2, 78, 218),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(double.infinity, 50), // Button width = container width
                  ),
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Voir les commandes'),
                ))),
                       Padding(
                padding: EdgeInsets.all(5.0),
                child: ElevatedButton.icon(
                        onPressed: _onEditEvent,
                         style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 2, 78, 218),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(double.infinity, 50), // Button width = container width
                  ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Modifier'),
                      )),
                       Padding(
                padding: EdgeInsets.all(5.0),
                child: 
                      ElevatedButton.icon(
                         style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    minimumSize: Size(double.infinity, 50), // Button width = container width
                  ),
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
                      )),
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
              style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }
}
