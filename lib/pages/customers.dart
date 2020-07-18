import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/customer.dart';
import 'package:lifesweettreatsordernotes/requests/customers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  List<Customer> customers = List<Customer>();
  bool loaded_customers = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
  }

  void getCustomer() async {
    customers = await CustomersData().getCustomers();
    setState(() {
      customers = customers;
      loaded_customers = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: (loaded_customers) ? Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pink,
                Colors.white
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
            )
        ),
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: customers.map((Customer customer) {
              return Container(
    //              width: 80.0,
                height: 100.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.topCenter,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(Icons.edit, size: 18),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.person, size: 50),
                        Text('${customer.fname} ${customer.lname}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
        ),
      ) : Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitDoubleBounce(
                color: Colors.pink[100],
                size: 90.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
