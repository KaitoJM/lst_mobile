import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/pages/sessions.dart';
import 'pages/home.dart';
import 'pages/order_form.dart';
import 'pages/loading.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/loading',
    routes: {
      '/home': (context) => OrderList(),
      '/loading': (context) => Loading(),
      '/sessions': (context) => SessionList(),
      '/new_order': (context) => OrderForm(),
    },
  ));
}
