import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_flutter/components/events/eventLikedList.dart';
import 'package:ticket_flutter/components/events/eventListPageClient.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 157, 192, 249),
      body: EventListPageClient()
    );
  }
}