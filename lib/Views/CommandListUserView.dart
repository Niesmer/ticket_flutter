import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/commandListUser.dart';

class CommandListUserView extends StatelessWidget {
  const CommandListUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
               backgroundColor: Color.fromARGB(255, 157, 192, 249),

      body: CommandListUser(),
    );
  }
}
