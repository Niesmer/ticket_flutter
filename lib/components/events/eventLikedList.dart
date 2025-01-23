import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart';
import 'eventListRowClient.dart';

class Eventlikedlist extends StatefulWidget {
  const Eventlikedlist({super.key});

  @override
  _EventlikedlistState createState() => _EventlikedlistState();
}

class _EventlikedlistState extends State<Eventlikedlist> {
  late Future<List<Event>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = Event.getLikedEvents();
  }

   void _refreshEvents() {
    setState(() {
      _futureEvents = Event.getLikedEvents(); // Refresh event list
    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 157, 192, 249),
          appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 157, 192, 249),
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                centerTitle: true,
                title: Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: Text('LISTE DE VOS LIKES',textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 2, 78, 218),
                        fontWeight: FontWeight.w800),)
      )),
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
             return Padding(
                    padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child:  ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                if (events[index].state == 0){
                  return EventListRowClient(
                  event: events[index],
                  onEventChanged: _refreshEvents, // Callback to refresh list
                );
                }
                return null;
                
              },
            ));
          }
        },
      ),
    ));
  }

  
}
