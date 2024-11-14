import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ticket_flutter/main.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://rhhbleufpaxszilpbkjn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJoaGJsZXVmcGF4c3ppbHBia2puIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE0ODg1ODIsImV4cCI6MjA0NzA2NDU4Mn0.z8T0eHxBdavBVKNEgdTXAgv7ahOF5mxfCyA1t0Bxpls',
  );
  runApp(MyApp());
}