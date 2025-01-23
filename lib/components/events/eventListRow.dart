import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import './eventInfos.dart';
import 'package:ticket_flutter/utils.dart';

class EventListRow extends StatelessWidget {
  final Event event;
  final VoidCallback onEventChanged;

  const EventListRow({
    super.key,
    required this.event,
    required this.onEventChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),  // Espacement vertical
      child: ListTile(
      contentPadding: EdgeInsets.all(10),
      tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),

      title: Text('${event.name} - ${event.location}'),
      subtitle: Text(
        'Début: ${parseDate(event.eventDateStart, event.eventTimeStart)} \n'
        'Fin: ${parseDate(event.eventDateEnd, event.eventTimeEnd)}\n'
        'Tickets: ${event.ticketsNbr}',
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventInfos(
              eventId: event.id,
              onEventChanged: onEventChanged, // Transmet le callback
            ),
          ),
        );

        // Si les modifications ont été effectuées dans EventInfos, appelle le callback
        if (result == true) {
          onEventChanged();
        }
      },
    ));
  }
}
