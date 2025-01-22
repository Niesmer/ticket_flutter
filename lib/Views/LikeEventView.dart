import 'package:flutter/material.dart';
import 'package:ticket_flutter/components/events/eventLikedList.dart';
import 'package:ticket_flutter/login_signup.dart';

class LikedEventView extends StatelessWidget {
  const LikedEventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 157, 192, 249),
      body: Eventlikedlist(),
    );
  }
}
