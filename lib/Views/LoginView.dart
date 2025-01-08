import 'package:flutter/material.dart';
import 'package:ticket_flutter/login_signup.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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
