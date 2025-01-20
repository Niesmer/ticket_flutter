import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/eventListPage.dart';
import 'package:ticket_flutter/components/events/eventListPageClient.dart';

class Admineventview extends StatelessWidget {
  const Admineventview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Events Administation'),
      ),
      body: EventListPage()
    );
  }
}