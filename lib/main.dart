import 'package:flutter/material.dart';
import 'package:ticket_flutter/utils.dart';
import 'event.dart';
import 'supabaseConnection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion des événements',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EventListPage(),
    );
  }
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = Event.getAll();
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
                final event = events[index];
                return ListTile(
                  title: Text('${event.name} - ${event.location}'),
                  subtitle: Text(
                    'Début: ${parseDate(event.eventDateStart, event.eventTimeStart)}\n'
                    'Fin: ${parseDate(event.eventDateEnd, event.eventTimeEnd)}\n'
                    'Tickets: ${event.ticketsNbr}',
                  ),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventForm(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddEventForm(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEventForm(
          onEventCreated: () {
            setState(() {
              _futureEvents = Event.getAll();
            });
          },
        ),
      ),
    );
  }
}

class AddEventForm extends StatefulWidget {
  final VoidCallback onEventCreated;

  AddEventForm({required this.onEventCreated});

  @override
  _AddEventFormState createState() => _AddEventFormState();
}

class _AddEventFormState extends State<AddEventForm> {
  final _formKey = GlobalKey<FormState>();
  List<String>? _errors;
  String? _name;
  DateTime? _eventDateStart;
  TimeOfDay? _eventTimeStart;
  DateTime? _eventDateEnd;
  TimeOfDay? _eventTimeEnd;
  String? _location;
  int? _ticketsNbr;
  DateTime? _openingDateTicket;
  TimeOfDay? _openingTimeTicket;
  DateTime? _closingDateTicket;
  TimeOfDay? _closingTimeTicket;

  Future<void> _selectDate(BuildContext context, DateTime? initialDate, Function(DateTime) onDateSelected) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateSelected(picked);
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime, Function(TimeOfDay) onTimeSelected) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null) onTimeSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom de l\'événement'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Veuillez entrer un nom.';
                return null;
              },
              onSaved: (value) => _name = value,
            ),
            ListTile(
              title: Text('Date de début'),
              subtitle: Text(_eventDateStart != null ? '${_eventDateStart!.toLocal()}' : 'Sélectionner une date'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, _eventDateStart, (date) {
                setState(() => _eventDateStart = date);
              }),
            ),
            ListTile(
              title: Text('Heure de début'),
              subtitle: Text(_eventTimeStart != null ? _eventTimeStart!.format(context) : 'Sélectionner une heure'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, _eventTimeStart, (time) {
                setState(() => _eventTimeStart = time);
              }),
            ),
            ListTile(
              title: Text('Date de fin'),
              subtitle: Text(_eventDateEnd != null ? '${_eventDateEnd!.toLocal()}' : 'Sélectionner une date'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, _eventDateEnd, (date) {
                setState(() => _eventDateEnd = date);
              }),
            ),
            ListTile(
              title: Text('Heure de fin'),
              subtitle: Text(_eventTimeEnd != null ? _eventTimeEnd!.format(context) : 'Sélectionner une heure'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, _eventTimeEnd, (time) {
                setState(() => _eventTimeEnd = time);
              }),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Lieu'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Veuillez entrer un lieu.';
                return null;
              },
              onSaved: (value) => _location = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre de tickets'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Veuillez entrer un nombre de tickets valide.';
                }
                return null;
              },
              onSaved: (value) => _ticketsNbr = int.parse(value!),
            ),
            ListTile(
              title: Text('Date d\'ouverture des tickets'),
              subtitle: Text(_openingDateTicket != null ? '${_openingDateTicket!.toLocal()}' : 'Sélectionner une date'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, _openingDateTicket, (date) {
                setState(() => _openingDateTicket = date);
              }),
            ),
            ListTile(
              title: Text('Heure d\'ouverture'),
              subtitle: Text(_openingTimeTicket != null ? _openingTimeTicket!.format(context) : 'Sélectionner une heure'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, _closingTimeTicket, (time) {
                setState(() => _openingTimeTicket = time);
              }),
            ),
            ListTile(
              title: Text('Date de fermeture des tickets'),
              subtitle: Text(_closingDateTicket != null ? '${_closingDateTicket!.toLocal()}' : 'Sélectionner une date'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(context, _closingDateTicket, (date) {
                setState(() => _closingDateTicket = date);
              }),
            ),
            ListTile(
              title: Text('Heure de fermeture'),
              subtitle: Text(_closingTimeTicket != null ? _closingTimeTicket!.format(context) : 'Sélectionner une heure'),
              trailing: Icon(Icons.access_time),
              onTap: () => _selectTime(context, _closingTimeTicket, (time) {
                setState(() => _closingTimeTicket = time);
              }),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Ajouter'),
            ),
            ElevatedButton(onPressed: _closeForm, child: Text('Annuler'))
          ],
        ),
      ),
    );
  }

void _closeForm() {
  Navigator.of(context).pop(); // Ferme la page ou le formulaire actuel
}
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      

      await Event.createOne(
         _name!,
         _eventDateStart!,
         _eventDateEnd!,
         _eventTimeStart!,
         _eventTimeEnd!,
         _location!,
        _ticketsNbr!,
         _openingDateTicket!,
         _openingTimeTicket!,
         _openingDateTicket!,
         _openingTimeTicket!,
        1, // Example: replace with actual user ID
      );

      widget.onEventCreated();
      Navigator.pop(context);
    }
  }
}
