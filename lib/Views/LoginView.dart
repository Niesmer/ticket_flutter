import 'package:flutter/material.dart';
import 'package:ticket_flutter/login_signup.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: LoginSignup(),
    );
  }
}