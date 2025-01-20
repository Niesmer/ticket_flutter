import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:ticket_flutter/utils.dart';

class CommandPage extends StatefulWidget {
  final int eventId;
  final UserProfile? user;

  const CommandPage({
    super.key,
    required this.eventId,
    required this.user,
  });

  @override
  _CommandState createState() => _CommandState();
}

class _CommandState extends State<CommandPage> {
  final _formKey = GlobalKey<FormState>();
  int _ticketQuantity = 1;
  String? _error;
  List<String> _seats = [];
  late Future<Event> _event;

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  Future<bool> _submitOrder() async {
  if (_formKey.currentState?.validate() ?? false) {
    _formKey.currentState!.save();

    setState(() {
      _error = null;
    });

    try {
      _seats = await getSeatNumbers(_ticketQuantity, widget.eventId);
      return true; // Indique que la soumission a réussi
    } catch (e) {
      setState(() {
        _error = e.toString();
        print(_error);
      });
      return false; // Indique un échec
    }
  }
  return false; // Indique que la validation a échoué
}

  Future<void> _fetchEvent() async {
    setState(() {
      _event = Event.getOne(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commander un billet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Event>(
          future: _event,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Aucun événement trouvé.'));
            } else {
              final event = snapshot.data!;
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evenement : ${event.name}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _ticketQuantity.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Quantité de billets',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            int.tryParse(value) == null ||
                            int.parse(value) <= 0) {
                          return 'Veuillez entrer un nombre de tickets valide.';
                        }
                        if (event.ticketsNbr - int.parse(value) < 0){
                          return 'Le nombre de tickets disponibles ne permet pas de commander cette quantité.';
                        }
                        return null;
                      },
                      onSaved: (value) => _ticketQuantity = int.parse(value!),
                    ),
                    const SizedBox(height: 16),
                    if (_error != null)

                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        bool isOrderAccepted = await _submitOrder();
                        if (isOrderAccepted) {
                          final confirm = await _showConfirmationDialog(
                            context, event, widget.user, _ticketQuantity);
                        if (confirm == true) {
                          // Assuming Command.createOne is defined elsewhere
                          await Command.createOne(
                              event.id, widget.user!.id, _seats);
                          Event.updateTickets(event.id, event.ticketsNbr - _ticketQuantity);
                          Navigator.pop(context, true); // Retourne à la liste
                        }
                        }
                        
                      },
                      child: const Text('Commander'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<bool?> _showConfirmationDialog(
    BuildContext context, Event event, UserProfile? user, int? ticketQuantity) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Récapitulatif'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evenement',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              event.name,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Du ${parseDate(event.eventDateStart, event.eventTimeStart)} au ${parseDate(event.eventDateEnd, event.eventTimeEnd)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Vous',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            Text(
              'Nom : ${user!.nom}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Prenom : ${user.prenom}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Email : ${user.nom}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              'Total : ${ticketQuantity! * event.price} €',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Payer'),
          ),
        ],
      );
    },
  );
}
