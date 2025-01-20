import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_flutter/components/events/eventLikedList.dart';
import 'package:ticket_flutter/components/events/eventListPageClient.dart';
import 'package:ticket_flutter/main.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: EventListPageClient()
    );
  }
}