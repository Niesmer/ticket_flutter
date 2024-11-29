import 'package:flutter/material.dart';
import 'package:ticket_flutter/Views/HomeView.dart';
import 'package:ticket_flutter/Views/LoginView.dart';
import 'package:ticket_flutter/supabase.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  SupaConnect();
  setUrlStrategy(PathUrlStrategy()); // Configure to use path-based URLs
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/', // Set initial route to '/login'
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomeView(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginView(),
        ),
      ],
      
    );

    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
