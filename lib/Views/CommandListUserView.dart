import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/commandListUser.dart';

class CommandListUserView extends StatelessWidget {
  const CommandListUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command List'),
      ),
      body: CommandListUser(),
    );
  }
}
