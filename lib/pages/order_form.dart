import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/order.dart';
import 'package:lifesweettreatsordernotes/models/orderItem.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';

class OrderForm extends StatefulWidget {
  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  Map data;
  int sessionId;
  Order order;
  var productFieldController = TextEditingController();
  var productQtyFieldController = TextEditingController();

  List<SessionProduct> productOption = List<SessionProduct>();

  //form data
  int customer;
  int author;
  List<OrderItem> items = List<OrderItem>();

  int productIndx;
  int qty;

  bool loadedOption = false;

  void getProductOptions() async {
    Response response = await get('http://172.18.5.209:8080/api/get-sessions-products/${sessionId}');
    List<dynamic> options = json.decode(response.body);
    List<SessionProduct> option_temp = List<SessionProduct>();

    options.forEach((option) {
      option_temp.add(new SessionProduct(
          id: option['id'],
          productId: option['product_id'],
          productName: option['product_name'],
          qty: option['quantity'],
          price: option['price'].toDouble()
      ));
    });

    setState(() {
      productOption = option_temp;
      loadedOption = true;
    });

    print('product option was loaded');
    print(productOption);
  }

  Widget totalAmount(List<OrderItem> items) {
    double total = 0;

    items.forEach((element) {
      total += element.qty * element.price;
    });

    return Text(
      'TOTAL: ${total.toString()}',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    setState(() {
      sessionId = data['session_id'];

      if (!loadedOption) {
        getProductOptions();
      }
    });

    order = data['order'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Order'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),
              Text('Delivery Information'),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Author',
                ),
              ),
              SizedBox(height: 10),
              Divider(height: 10),
              SizedBox(height: 10),
              Text('Order Information'),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: DropdownButtonFormField<int>(
                      items: productOption.map((SessionProduct value) {
                        return new DropdownMenuItem<int>(
                          value: productOption.indexOf(value),
                          child: new Text(value.productName),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Product',
                      ),
                      onChanged: (val) {
                        productIndx = val;
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      onChanged: (val) {
                        qty = int.parse(val);
                      },
                      controller: productQtyFieldController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Quantity',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              RaisedButton.icon(
                onPressed: (){
                  setState(() {
                    items.add(
                      new OrderItem(productId: productOption[productIndx].productId, qty: qty, price: productOption[productIndx].price, productName: productOption[productIndx].productName)
                    );
                  });

                  productQtyFieldController.clear();
                },
                padding: EdgeInsets.all(10),
                icon: Icon(Icons.add,
                  color: Colors.white
                ),
                label: Text('Add product to order',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                color: Colors.pinkAccent,
              ),
              SizedBox(height: 10),
              Divider(height: 10),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Products'),
                  totalAmount(items)
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: items.map((item) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(flex: 1, child: Text(item.qty.toString())),
                      Expanded(flex: 8, child: Text(item.productName)),
                      Expanded(flex: 2, child: Text('x ${item.price}')),
                      Expanded(
                          flex: 2,
                          child: Text(
                            '${item.price * item.qty}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            items.remove(item);
                          });
                        },
                        icon: Icon(Icons.clear),
                      )
                    ],
                  );
                }).toList()
              ),
              SizedBox(height: 10),
              Divider(height: 10),
              SizedBox(height: 10),
              RaisedButton.icon(
                onPressed: (){

                },
                padding: EdgeInsets.all(10),
                icon: Icon(Icons.save,
                    color: Colors.white
                ),
                label: Text('Publish Order',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: Colors.pinkAccent,
              )
            ],
          ),
        )
      ),
    );
  }
}
