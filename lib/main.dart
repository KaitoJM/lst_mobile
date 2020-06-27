import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/pages/new_session_form.dart';
import 'package:lifesweettreatsordernotes/pages/sessions.dart';
import 'pages/home.dart';
import 'pages/order_form.dart';
import 'pages/loading.dart';
import 'pages/edit_order_items.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/loading',
    routes: {
      '/home': (context) => OrderList(),
      '/loading': (context) => Loading(),
      '/edit_order': (context) => EditOrderItems(),
      '/sessions': (context) => SessionList(),
      '/new_session': (context) => NewSessionForm(),
      '/new_order': (context) => OrderForm(),
    },
  ));
}
