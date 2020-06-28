import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/models/product.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class NewSessionForm extends StatefulWidget {
  @override
  _NewSessionFormState createState() => _NewSessionFormState();
}

class _NewSessionFormState extends State<NewSessionForm> {
  dynamic data;
  List<Product> products = List<Product>();
  List<SessionProduct> productItems = List<SessionProduct>();
  bool loading = false;

  Session form = Session(startDate: '', products: List<SessionProduct>());
  Product selectedProduct;

  Future <List<Product>> getProducts() async {
    print('Loading products');
    setState(() {
      loading = true;
    });
    Response response = await get('${global.api_url}get-products');
    print('Loaded products');
    setState(() {
      loading = false;
    });
    List<dynamic> productTemp = jsonDecode(response.body);
    products.clear();

    setState(() {
      productTemp.forEach((prod) {
        products.add(new Product(
          id: prod['id'],
          name: prod['name'],
          price: prod['price'].toDouble(),
          categoryId: prod['category_id'],
          image: prod['image'],
        ));
      });

    });
  }

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

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    form = (data != null) ? data['session'] : form;

    return Scaffold(
      appBar: AppBar(
        title: Text('New Session'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          if (loading)
          LinearProgressIndicator(
            backgroundColor: Colors.pinkAccent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text('SESSION INFORMATION'),
                  SizedBox(height: 10),
                  TextFormField(
                    initialValue: form.name,
                    onChanged: (val) {
                      form.name = val;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  OutlineButton.icon(
                    padding: EdgeInsets.all(10),
                    icon: Icon(Icons.date_range, color: Colors.pinkAccent),
                    label: Text((form.startDate == null) ? 'Schedule Date' : '${form.startDate}',
                      style: TextStyle(
                        color: Colors.pinkAccent
                      ),
                    ),
                    borderSide: BorderSide(
                      color: Colors.pinkAccent,
                      width: 2
                    ),
                    onPressed: () {
                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2022)
                      ).then((date) {
                        print(date.toString());
                        setState(() {
                          form.startDate = date.toString();
                        });
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Divider(height: 10),
                  SizedBox(height: 10),
                  Text('PRODUCTS AVAILABLE'),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<Product>(
                          isExpanded: true,
                          value: selectedProduct,
                          items: products.map((Product value) {
                            return new DropdownMenuItem<Product>(
                              value: value,
                              child: new Text('${value.name}'),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Products',
                          ),
                          onChanged: (val) {
                            selectedProduct = val;
                          },
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(20),
                        onPressed: () {
                          print(selectedProduct);
                          setState(() {
                            form.products.add(
                                SessionProduct(
                                  productId: selectedProduct.id,
                                  productName: selectedProduct.name,
                                  price: selectedProduct.price,
                                  qty: 0,
                                )
                            );
                          });
                        },
                        icon: Icon(Icons.add,
                          color: Colors.black54,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                      children: form.products.map((item) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(flex: 8, child: Text(item.productName)),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                initialValue: item.qty.toString(),
                                onChanged: (val) {
                                  setState(() {
                                    form.products[form.products.indexOf(item)].qty = int.parse(val);
                                  });
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(0),
                                  labelText: 'Qty',
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(flex: 2, child: Text('${item.price}')),
                            IconButton(
                              onPressed: () {
                                form.products.remove(item);

                                setState(() {
                                  form.products.remove(item);
                                });
                              },
                              icon: Icon(Icons.clear),
                            )
                          ],
                        );
                      }).toList()
                  ),
                  SizedBox(height: 10),
                  RaisedButton.icon(
                    padding: EdgeInsets.all(10),
                    onPressed: () async {
                      if (!loading) {
                        print('Adding session..');
                        setState(() {
                          loading = true;
                        });
                        Response response = await post('${global.api_url}add-session',
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, dynamic>{
                              'id': form.id,
                              'name': form.name,
                              'start_date': form.startDate,
                              'products': jsonEncode(form.products)
                            })
                        );
                        setState(() {
                          loading = false;
                        });
                        print('finished Add action..');
                        print(response.body);
                        Map responseMap = json.decode(response.body);

                        if (responseMap['err'] == 0) {
                          Navigator.pop(context, true);
                        } else {
                          _showErrorMessage('Woah!', responseMap['msg']);
                        }
                      }
                    },
                    icon: Icon((loading) ? Icons.more_horiz : Icons.save_alt, color: Colors.white),
                    label: Text(
                        (loading) ? 'Loading...' : 'Schedule Session',
                        style: TextStyle(
                          color: Colors.white
                        )
                    ),
                    color: Colors.pinkAccent,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//class FormData {
//  List<SessionProduct> products = List<SessionProduct>();
//  int id;
//  String name;
//  String startDate;
//  String endDate;
//  int status;
//
//  FormData({this.id, this.name, this.startDate, this.products});
//}

