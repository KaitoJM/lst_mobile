import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/requests/sessions.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Deliveries extends StatefulWidget {
  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Deliveries> {
  bool loading = false;

  List<Session> sessions = List<Session>();
  bool loaded_session = false;

  void setSession() async {
    if (!loaded_session) {
      setState(() {
        loading = true;
      });

      List<Session> temp = await SessionsData().getDeliveries();
      setState(() {
        loading = false;
        sessions = temp;
        loaded_session = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliveries'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: (sessions.length > 0) ? Container(
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
        child: Center(
          child: CarouselSlider (
              options: CarouselOptions(
                height: 400,
                autoPlay: false,
                enlargeCenterPage: true,
              ),
              items: sessions.map((session) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 15),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(session.assigneeName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: session.products.map((product) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text('${product.productName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Text('₱${product.totalPaid()}',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pinkAccent
                                                ),
                                              ),
                                              Text('/₱${product.total()}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      children: product.orderItems.map((item) {
                                        return Row(
                                          children: <Widget>[
                                            SizedBox(width: 12),
                                            (item.order.status == 1) ?
                                              Icon(Icons.check) :
                                              Icon(Icons.hourglass_empty),
                                            Text('${item.qty} ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12
                                              ),
                                            ),
                                            Text('${item.order.customerFName} ', overflow: TextOverflow.ellipsis),
                                            Text('${item.order.customerLName} ', overflow: TextOverflow.ellipsis),
                                            Text('x ${item.price} '),
                                            Expanded(
                                              child: Text('₱${item.totalComuted()} ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12
                                                ),
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Divider(height:10),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Text('TOTAL :'),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('₱${session.total_paid()}',
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pinkAccent
                                      ),
                                    ),
                                    Text('/₱${session.total()}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList()
          ),
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
