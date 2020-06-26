import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/models/orderItem.dart';

import 'package:lifesweettreatsordernotes/requests/sessions.dart';
import 'package:lifesweettreatsordernotes/requests/orders.dart';

class EditOrderItems extends StatefulWidget {
  @override
  _EditOrderItemsState createState() => _EditOrderItemsState();
}

class _EditOrderItemsState extends State<EditOrderItems> {
  Map data = {};
  int session_id;
  int order_id;
  String customer_name;
  List<OrderItem> orderItems = List<OrderItem>();

  FormData form = FormData(items: List<OrderItem>());
  var productQtyFieldController = TextEditingController();

  List<SessionProduct> productOption = List<SessionProduct>();

  int productIndx;
  int qty;

  bool loadedOption = false;

  Future<void> _showErrorMessage(String title, String msg) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void getProductOptions() async {
    List<SessionProduct> option_temp = await SessionsData().getSessionProducts(session_id);

    setState(() {
      productOption = option_temp;
      loadedOption = true;
    });

    print('product option was loaded');
  }

  Widget totalAmount(List<OrderItem> items) {
    double total = 0;

    items.forEach((element) {
      total += element.qty * element.price;
    });

    return Text(
      'TOTAL: ₱${total.toString()}',
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    print(data['order_id']);
    List<dynamic> itemsArrray = jsonDecode(data['order_items']);

    setState(() {
      order_id = data['order_id'];
      session_id = data['session_id'];
      customer_name = data['customer_name'];

      if (!loadedOption) {

        itemsArrray.forEach((item) {
          orderItems.add(
              new OrderItem(
                  id: item['id'],
                  image: item['image'],
                  price: item['price'].toDouble(), //parse to double
                  productId: item['product_id'],
                  sessionProductId: item['session_product_id'],
                  productName: item['product_name'],
                  qty: item['qty'],
                  total: item['total'].toDouble()
              )
          );
        });

        form.items = orderItems;
        getProductOptions();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Order'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Container(
          child: ListView(
            children: <Widget>[
              Text(
                customer_name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
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
                  OrderItem itemTemp = new OrderItem(sessionProductId: productOption[productIndx].id, productId: productOption[productIndx].productId, qty: qty, price: productOption[productIndx].price, productName: productOption[productIndx].productName);
//                  form.items.add(itemTemp);

                  setState(() {
                    orderItems.add(itemTemp);
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
                  totalAmount(orderItems)
                ],
              ),
              SizedBox(height: 10),
              Column(
                  children: orderItems.map((item) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(item.productName),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.amber, width: 1, style: BorderStyle.solid),
                                          color: Colors.amber[100],
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 50,
                                              child: IconButton(
                                                color: Colors.black45,
                                                onPressed: () {
                                                  setState(() {
                                                    item.qty--;
                                                  });
                                                },
                                                icon: Icon(Icons.remove),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: Text(item.qty.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45
                                                  ),
                                                )
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: IconButton(
                                                color: Colors.black45,
                                                onPressed: () {
                                                  setState(() {
                                                    item.qty++;
                                                  });
                                                },
                                                icon: Icon(Icons.add),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 50),
                                      Expanded(flex: 1, child: Text('x ${item.price}')),
                                      Expanded(
                                          child: Text(
                                            '₱${item.price * item.qty}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold
                                            ),
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              form.items.remove(item);

                              setState(() {
                                orderItems.remove(item);
                              });
                            },
                            icon: Icon(Icons.clear),
                          ),
                        ],
                      ),
                    );
                  }).toList()
              ),
              SizedBox(height: 10),
              Divider(height: 10),
              SizedBox(height: 10),
              RaisedButton.icon(
                onPressed: () async {
                  try {
                    Map responseMap = await OrdersData().updateOrder(order_id, jsonEncode(form.items));
                    print(responseMap);

                    if (responseMap['err'] == 0) {
                      Navigator.pop(context, true);
                    } else {
                      _showErrorMessage('Woah!', responseMap['msg']);
                    }
                  } catch (Error) {
                    _showErrorMessage('Heyla!', 'Please fill up all the given information.');
                  }

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
        ),
      ),
    );
  }
}

class FormData {
  List<OrderItem> items = List<OrderItem>();

  FormData({this.items});

}
