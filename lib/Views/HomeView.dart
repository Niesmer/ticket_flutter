import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_flutter/main.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home View'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/login');
          },
          child: Text('Go to Login'),
        ),
      ),
    );
  }
}