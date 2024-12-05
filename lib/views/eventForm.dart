import 'package:flutter/material.dart';
import 'package:ticket_flutter/event.dart';

class EventForm extends StatefulWidget {
  const EventForm({super.key});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
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

      Navigator.pop(context);
    }
  }
}