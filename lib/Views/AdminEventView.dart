import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/eventListPage.dart';
import 'package:ticket_flutter/components/events/eventListPageClient.dart';

class Admineventview extends StatelessWidget {
  const Admineventview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Color.fromARGB(255, 157, 192, 249),

      body: EventListPage()
    );
  }
}