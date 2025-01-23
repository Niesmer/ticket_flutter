import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/like_btn.dart';
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
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadEvent();
    _user = currentUser;
    _checkIfLiked();
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
      widget.onEventChanged();
      _loadEvent();
    }
  }

  Future<void> _checkIfLiked() async {
    final isLiked = await Event.isEventLikedByUser(widget.eventId, _user!.id);
    setState(() {
      _isLiked = isLiked;
    });
  }

  Future<void> _toggleLike() async {
    try {
      if (_isLiked) {
        await Event.unlikeEvent(widget.eventId, _user!.id);
      } else {
        await Event.likeEvent(widget.eventId, _user!.id);
      }
      setState(() {
        _isLiked = !_isLiked;
      });
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          LikeBtn(isLiked: _isLiked, onTap: _toggleLike)
                        ]),
                  ),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Lieu : ${event.location}')),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Début : ${parseDate(event.eventDateStart, event.eventTimeStart)}',
                      )),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Fin :  ${parseDate(event.eventDateEnd, event.eventTimeEnd)}',
                      )),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Prix : ${event.price} €',
                      )),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Ouverture Billeterie : ${parseDate(event.openingDateTicket, event.openingTimeTicket)}',
                      )),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Fermeture Billeterie :  ${parseDate(event.closingDateTicket, event.closingTimeTicket)}',
                      )),
                  
                  
                  if (!validateTicketOpening(
                      event.openingDateTicket, event.openingTimeTicket)) ...[
                    const Center( 
        
                      child: Text(
                      "La billeterie n'est pas encore ouverte.",
                      textAlign: TextAlign.center,
                    )),
                  ] else if (!validateTicketClosing(
                      event.closingDateTicket, event.closingTimeTicket)) ...[
                    const Center(child: Text(
                      "La billeterie est fermée",
                      textAlign: TextAlign.center,
                    )),
                  ] else if (event.ticketsNbr <= 0) ...[
                    const Center( child: Text(
                      "Il n'y a plus de tickets disponibles.",
                      textAlign: TextAlign.center,
                    )),
                  ] else ...[
                    
                      
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: (ElevatedButton.icon(
                              onPressed: _onCommand,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 2, 78, 218),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                minimumSize: Size(double.infinity,
                                    50),
                              ),
                              icon: const Icon(Icons.book_online),
                              label: const Text('Commander'),
                            )
                            )
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
