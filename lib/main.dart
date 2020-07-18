import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/pages/deliveries.dart';
import 'package:lifesweettreatsordernotes/pages/new_session_form.dart';
import 'package:lifesweettreatsordernotes/pages/sessions.dart';
import 'pages/history_details.dart';
import 'pages/home.dart';
import 'pages/order_form.dart';
import 'pages/loading.dart';
import 'pages/edit_order_items.dart';
import 'pages/login.dart';
import 'pages/assignments.dart';
import 'pages/transaction.dart';
import 'pages/customers.dart';
import 'pages/products.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/loading',
    routes: {
      '/login': (context) => Login(),
      '/home': (context) => OrderList(),
      '/loading': (context) => Loading(),
      '/edit_order': (context) => EditOrderItems(),
      '/sessions': (context) => SessionList(),
      '/new_session': (context) => NewSessionForm(),
      '/new_order': (context) => OrderForm(),
      '/history_details': (context) => HistoryDetails(),
      '/assignments': (context) => Assignments(),
      '/deliveries': (context) => Deliveries(),
      '/transaction': (context) => Transaction(),
      '/customers': (context) => Customers(),
      '/products': (context) => Products()
    },
  ));
}
