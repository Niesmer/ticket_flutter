import 'package:flutter/material.dart';
import 'package:ticket_flutter/views/eventInfos.dart';
import 'package:ticket_flutter/utils.dart';
import '../event.dart';

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
    return ListTile(
      title: Text('${event.name} - ${event.location}'),
      subtitle: Text(
        'Début: ${parseDate(event.eventDateStart, event.eventTimeStart)} \n'
        'Fin: ${parseDate(event.eventDateEnd, event.eventTimeEnd)}\n'
        'Tickets: ${event.ticketsNbr}',
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventInfos(eventId: event.id),
          ),
        );
      },
    );
  }
}
