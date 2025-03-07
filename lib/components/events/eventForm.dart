import 'package:flutter/material.dart';
import 'package:ticket_flutter/global.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:ticket_flutter/utils.dart';

class EventForm extends StatefulWidget {
  final int? eventId;

  const EventForm({super.key, this.eventId});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  List<String>? _errors;

  // Champs du formulaire
  String? _name;
  int? _price;
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
  Event? _currentEvent;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) {
      _loadEventDetails();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadEventDetails() async {
    try {
      final event = await Event.getOne(widget.eventId!);
      setState(() {
        _currentEvent = event;
        _name = event.name;
        _price = event.price;
        _eventDateStart = event.eventDateStart;
        _eventTimeStart = event.eventTimeStart;
        _eventDateEnd = event.eventDateEnd;
        _eventTimeEnd = event.eventTimeEnd;
        _location = event.location;
        _ticketsNbr = event.ticketsNbr;
        _openingDateTicket = event.openingDateTicket;
        _openingTimeTicket = event.openingTimeTicket;
        _closingDateTicket = event.closingDateTicket;
        _closingTimeTicket = event.closingTimeTicket;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errors = ['Erreur lors du chargement des données : $e'];
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    // Get current date
    final now = DateTime.now();

    // Determine the initial date, ensuring it's not before today
    final effectiveInitialDate = initialDate != null
        ? (initialDate.isBefore(now) ? now : initialDate)
        : now;

    final picked = await showDatePicker(
      context: context,
      initialDate: effectiveInitialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateSelected(picked);
  }

  Future<void> _selectTime(BuildContext context, TimeOfDay? initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
    );
    if (picked != null) onTimeSelected(picked);
  }

  void _submitForm() async {
    _errors = [];
    bool update;

    if(_currentEvent != null ){
       update = true;
    }
    else {
      update = false;
    }
    final newErrors = validateDates(
      update,
      _openingDateTicket,
      _closingDateTicket,
      _openingTimeTicket,
      _closingTimeTicket,
      _eventDateStart,
      _eventDateEnd,
      _eventTimeStart,
      _eventTimeEnd,
    );

    setState(() {
      if (_errors == null) {
        _errors = newErrors;
      } else {
        _errors!.addAll(newErrors!);
      }
    });

    if (_errors != null && _errors!.isNotEmpty) {
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (widget.eventId != null) {
        // Mise à jour
        await Event.updateOne(
          widget.eventId!,
          _name!,
          _price!,
          _eventDateStart!,
          _eventDateEnd!,
          _eventTimeStart!,
          _eventTimeEnd!,
          _location!,
          _ticketsNbr!,
          _openingDateTicket!,
          _openingTimeTicket!,
          _closingDateTicket!,
          _closingTimeTicket!,
        );
      } else {
        // Création
        await Event.createOne(
          _name!,
          _price!,
          _eventDateStart!,
          _eventDateEnd!,
          _eventTimeStart!,
          _eventTimeEnd!,
          _location!,
          _ticketsNbr!,
          _openingDateTicket!,
          _openingTimeTicket!,
          _closingDateTicket!,
          _closingTimeTicket!,
          currentUser!.id, // Remplacer par l'ID utilisateur réel
        );
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      
      appBar: AppBar(
        title: Text(widget.eventId != null
            ? 'Modifier Événement'
            : 'Ajouter Événement', style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 2, 78, 218),
                        fontWeight: FontWeight.w800
                        ), 
                  ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        
        child: Form(
          key: _formKey,
          child: 
          Padding(padding: EdgeInsets.all(20),
           child : Column(
            children: [
              if (_errors != null && _errors!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.redAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _errors!.map((error) => Text(error, style: const TextStyle(color: Colors.white))).toList(),
                  ),
                ),
              TextFormField(
                initialValue: _name,
                decoration:
                    const InputDecoration(labelText: 'Nom de l\'événement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom.';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                initialValue: _price?.toString(),
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Veuillez entrer un prix valide.';
                  }
                  return null;
                },
                onSaved: (value) => _price = int.parse(value!),
              ),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                title: const Text('Date de début'),
                subtitle: Text(_eventDateStart != null
                    ? parseDateOnly(_eventDateStart!)
                    : 'Sélectionner une date'),
                
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, _eventDateStart, (date) {
                  setState(() => _eventDateStart = date);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                title: const Text('Heure de début'),
                subtitle: Text(_eventTimeStart != null
                    ? _eventTimeStart!.format(context)
                    : 'Sélectionner une heure'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, _eventTimeStart, (time) {
                  setState(() => _eventTimeStart = time);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                title: const Text('Date de fin'),
                subtitle: Text(_eventDateEnd != null
                    ? parseDateOnly(_eventDateEnd!)
                    : 'Sélectionner une date'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, _eventDateEnd, (date) {
                  setState(() => _eventDateEnd = date);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15, bottom: 15), child : ListTile(
                title: const Text('Heure de fin'),
                subtitle: Text(_eventTimeEnd != null
                    ? _eventTimeEnd!.format(context)
                    : 'Sélectionner une heure'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, _eventTimeEnd, (time) {
                  setState(() => _eventTimeEnd = time);
                }),
              )),
              TextFormField(
                initialValue: _location,
                decoration: const InputDecoration(labelText: 'Lieu'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un lieu.';
                  }
                  return null;
                },
                onSaved: (value) => _location = value,
              ),
              TextFormField(
                initialValue: _ticketsNbr?.toString(),
                decoration:
                    const InputDecoration(labelText: 'Nombre de tickets'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      int.parse(value) <= 0) {
                    return 'Veuillez entrer un nombre de tickets valide.';
                  }
                  return null;
                },
                onSaved: (value) => _ticketsNbr = int.parse(value!),
              ),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                title: const Text('Date d\'ouverture des tickets'),
                subtitle: Text(_openingDateTicket != null
                    ? parseDateOnly(_openingDateTicket!)
                    : 'Sélectionner une date'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, _openingDateTicket, (date) {
                  setState(() => _openingDateTicket = date);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                title: const Text('Heure d\'ouverture'),
                subtitle: Text(_openingTimeTicket != null
                    ? _openingTimeTicket!.format(context)
                    : 'Sélectionner une heure'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, _openingTimeTicket, (time) {
                  setState(() => _openingTimeTicket = time);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15), child : ListTile(
                title: const Text('Date de fermeture des tickets'),
                subtitle: Text(_closingDateTicket != null
                    ? parseDateOnly(_closingDateTicket!)
                    : 'Sélectionner une date'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, _closingDateTicket, (date) {
                  setState(() => _closingDateTicket = date);
                }),
              )),
              Padding(padding: EdgeInsets.only(top:15, bottom : 15), child : ListTile(
                title: const Text('Heure de fermeture'),
                subtitle: Text(_closingTimeTicket != null
                    ? _closingTimeTicket!.format(context)
                    : 'Sélectionner une heure'),
                tileColor: Color.fromARGB(255, 79, 128, 218),
                iconColor: Colors.white,
textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(context, _closingTimeTicket, (time) {
                  setState(() => _closingTimeTicket = time);
                }),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 141, 150, 199),
                        ),
                    child:
                        Text(widget.eventId != null ? 'Modifier' : 'Ajouter', style: const TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _closeForm,
                    child: const Text('Annuler'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void _closeForm() {
    Navigator.of(context).pop();
  }
}
