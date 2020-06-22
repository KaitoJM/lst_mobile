import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/order.dart';
import 'package:lifesweettreatsordernotes/models/orderItem.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/models/customer.dart';
import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:lifesweettreatsordernotes/pages/home.dart';

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
  List<Customer> customers = List<Customer>();
  List<User> users = List<User>();

  //form data
  FormData form = FormData(items: List<OrderItem>());
  List<OrderItem> items = List<OrderItem>();

  int productIndx;
  int qty;

  bool loadedOption = false;
  bool loadedCustomers = false;
  bool loadedUsers = false;

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

    Response responseCustomer = await get('http://172.18.5.209:8080/api/get-customers');
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

    setState(() {
      customers = customer_temp;
      loadedCustomers = true;
    });
    print('customers option was loaded');

    Response responseUser = await get('http://172.18.5.209:8080/api/get-users');
    List<dynamic> userArray = json.decode(responseUser.body);
    List<User> user_temp = List<User>();

    userArray.forEach((user) {
      user_temp.add(new User(
          id: user['id'],
          fname: user['fname'],
          lname: user['lname'],
          email: user['email'],
          photo: user['photo']
      ));
    });

    setState(() {
      users = user_temp;
      loadedUsers = true;
    });
    print('users option was loaded');


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
              DropdownButtonFormField<int>(
                items: customers.map((Customer value) {
                  return new DropdownMenuItem<int>(
                    value: customers.indexOf(value),
                    child: new Text('${value.fname} ${value.lname}'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Customer',
                ),
                onChanged: (val) {
                  form.customer = customers[val];
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<int>(
                items: users.map((User value) {
                  return new DropdownMenuItem<int>(
                    value: users.indexOf(value),
                    child: new Text('${value.fname} ${value.lname}'),
                  );
                }).toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Author',
                ),
                onChanged: (val) {
                  form.userId = users[val].id;
                },
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
                  OrderItem itemTemp = new OrderItem(sessionProductId: productOption[productIndx].id, productId: productOption[productIndx].productId, qty: qty, price: productOption[productIndx].price, productName: productOption[productIndx].productName);
                  form.items.add(itemTemp);

                  setState(() {
                    items.add(itemTemp);
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
                onPressed: () async {
                  print(form);

                  Response response = await post('http://172.18.5.209:8080/api/submit-order',
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'session_id': sessionId,
                      'customer_id': form.customer.id.toString(),
                      'customer_fname': form.customer.fname,
                      'customer_lname': form.customer.lname,
                      'customer_email': form.customer.email,
                      'customer_phone': form.customer.phone,
                      'customer_address': form.customer.address,
                      'customer_gender': form.customer.gender,
                      'author_id': form.userId,
                      'items': jsonEncode(form.items)
                    })
                  );

                  Map responseMap = json.decode(response.body);
                  print(responseMap);
                  if (responseMap['err'] == 0) {
                    Navigator.pop(context, true);
//                    Navigator.pop(
//                        context,
//                        new MaterialPageRoute(
//                            builder: (BuildContext context) => new OrderList()));
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
        )
      ),
    );
  }
}

class FormData {
  Customer customer;
  int userId;
  List<OrderItem> items = List<OrderItem>();

  FormData({this.customer, this.userId, this.items});

}
