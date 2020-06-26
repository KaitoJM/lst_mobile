import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/customer.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class CustomersData {
  Future<List<Customer>> getCustomers() async {
    print('Loading Customers...');
    Response responseCustomer = await get('${global.api_url}get-customers');
    print('Loaded Customers');
    List<dynamic> customerArray = json.decode(responseCustomer.body);
    List<Customer> customer_temp = List<Customer>();

    customerArray.forEach((customer) {
      customer_temp.add(new Customer(
          id: customer['id'],
          fname: customer['fname'],
          lname: customer['lname'],
          email: customer['email'],
          phone: customer['phone'],
          address: customer['address'],
          gender: customer['gender']
      ));
    });

    return customer_temp;
  }

  Future<Map> submitCustomer(String fname, String lname, String email, String phone, String address, int gender) async {
    print('Submiting Customer data...');
    Response response = await post('${global.api_url}submit-customer',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fname': fname,
          'lname': lname,
          'email': email,
          'phone': phone,
          'address': address,
          'gender': gender,
        })
    );
    print('Customer finished process.');

    return json.decode(response.body);
  }
}