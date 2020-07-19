import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/customer.dart';

class CustomerForm extends StatefulWidget {
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  bool loaded = false;
  int customer_id;
  Map args;

  Customer customer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(customer_id);
  }

  void getCustomer() {
    if (!loaded) {
      int customer_id = args['id'];
      print(customer_id);
      loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    getCustomer();

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Customer'),
        centerTitle: true,
      ),
    );
  }
}
