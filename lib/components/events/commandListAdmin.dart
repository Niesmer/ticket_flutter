import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ticket_flutter/supabase.dart'; // Import the Supabase file

class CommandListAdmin extends StatefulWidget {
  final int eventId;

  const CommandListAdmin({super.key, required this.eventId});

  @override
  _CommandPageAdminState createState() => _CommandPageAdminState();
}

class _CommandPageAdminState extends State<CommandListAdmin> {
  late Future<List<Command>> _commandsFuture;

  @override
  void initState() {
    super.initState();
    _commandsFuture = Command.getCommandsByEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Les commandes de votre événement'),
        backgroundColor: Color.fromARGB(255, 157, 192, 249),
      ),
      backgroundColor: Color.fromARGB(255, 157, 192, 249),
      body: FutureBuilder<List<Command>>(
        future: _commandsFuture,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No commands found.'));
          } else {
            final commands = snapshot.data!;
            print(commands);
            return Padding(
                padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                child: ListView.builder(
                  itemCount: commands.length,
                  itemBuilder: (context, index) {
                    final command = commands[index];
                    return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0), // Espacement vertical
                        child: ListTile(
                          tileColor: Colors.white,
                          contentPadding: EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          title: Text('Command ID: ${command.id}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mail: ${command.user!.email}'),
                              Text(
                                  'Nom Prenom: ${command.user!.nom} ${command.user!.prenom}'),
                              Text('Sièges : ${command.seatNbr}'),
                            ],
                          ),
                        ));
                  },
                ));
          }
        },
      ),
    );
  }
}
