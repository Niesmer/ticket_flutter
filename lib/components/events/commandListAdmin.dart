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
        title: Text('Command Page Admin'),
      ),
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
            return ListView.builder(
              itemCount: commands.length,
              itemBuilder: (context, index) {
                final command = commands[index];
                return ListTile(
                  title: Text('Command ID: ${command.id}'),
                    subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mail: ${command.user!.email}'),
                      Text('Nom Prenom: ${command.user!.nom} ${command.user!.prenom}'),
                      Text('Sièges : ${command.seatNbr}'),
                    ],
                    ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
