import 'package:flutter/material.dart';

String parseDate(DateTime date, TimeOfDay time) {
  final day = date.toLocal().day.toString().padLeft(2, '0');
  final month = date.toLocal().month.toString().padLeft(2, '0');
  final year = date.toLocal().year.toString();
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');

  return '$day/$month/$year - ${hour}h${minute}';
}

bool validateDates(DateTime opening, DateTime closing, DateTime event){
  return true;
}