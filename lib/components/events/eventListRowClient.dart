import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/eventInfosClient.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:ticket_flutter/utils.dart';

class EventListRowClient extends StatelessWidget {
  final Event event;
  final VoidCallback? onEventChanged;

  const EventListRowClient({
    super.key,
    required this.event,
    this.onEventChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),  // Espacement vertical
      child: ListTile(
      tileColor: Colors.white,
      contentPadding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Text('${event.name} - ${event.location}'),
      subtitle: Text(
        'Début: ${parseDate(event.eventDateStart, event.eventTimeStart)} \n'
        'Fin: ${parseDate(event.eventDateEnd, event.eventTimeEnd)}\n'
        'Prix: ${event.price}€',
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventInfosClient(
              eventId: event.id,
              onEventChanged: onEventChanged ?? () {}, // Transmet le callback
            ),
          ),
        );

        // Si les modifications ont été effectuées dans EventInfos, appelle le callback
        if (result == true) {
        }
      },
    ));
  }
}
