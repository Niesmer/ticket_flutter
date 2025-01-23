import 'package:flutter/material.dart';
import 'package:ticket_flutter/global.dart';
import 'package:ticket_flutter/supabase.dart'; // Import the Supabase file

class CommandListUser extends StatefulWidget {
  const CommandListUser({super.key});

  @override
  _CommandListUserState createState() => _CommandListUserState();
}

class _CommandListUserState extends State<CommandListUser> {
  late Future<List<Command>> _commandsFuture;

  @override
  void initState() {
    super.initState();
    _commandsFuture = Command.getCommandsByUser(currentUser!.id);
  }

  Future<String> getEventName(int id)async {
    Event event = await Event.getOne(id);
    return event.name;
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
              child: Text('MES COMMANDES',textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 2, 78, 218),
                        fontWeight: FontWeight.w800)),
      )),
      body: FutureBuilder<List<Command>>(
        future: _commandsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No commands found.'));
          } else {
            final commands = snapshot.data!;
            return Padding(
                    padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                    child: ListView.builder(
              itemCount: commands.length,
              itemBuilder: (context, index) {
                final command = commands[index];
                
                return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),  // Espacement vertical
      child: ListTile(
        tileColor: Colors.white,
      contentPadding: EdgeInsets.all(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
      
                  title: FutureBuilder<String>(
                          future: getEventName(command.idEvent),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading event name...');
                            } else if (snapshot.hasError) {
                              return const Text('Error loading event name');
                            } else {
                              return Text('${snapshot.data}', style: TextStyle(fontWeight: FontWeight.w800),);
                            }
                          },
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mail: ${command.user!.email}'),
                            Text(
                                'Nom Prénom: ${command.user!.nom} ${command.user!.prenom}'),
                            Text('Sièges : ${command.seatNbr}'),
                          ],
                        ),
                      ),
                );
              },
            ));
          }
        },
      ),
    ));
  }
}
