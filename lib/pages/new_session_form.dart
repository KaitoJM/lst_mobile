import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/models/product.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class NewSessionForm extends StatefulWidget {
  @override
  _NewSessionFormState createState() => _NewSessionFormState();
}

class _NewSessionFormState extends State<NewSessionForm> {
  List<Product> products = List<Product>();
  List<SessionProduct> productItems = List<SessionProduct>();

  bool productsLoaded = false;
  FormData form = FormData(products: List<SessionProduct>());
  Product selectedProduct;

  Future <List<Product>> getProducts() async {
    Response response = await get('${global.api_url}get-products');
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

      productsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!productsLoaded) {
      getProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('New Session'),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20),
            Text('SESSION INFORMATION'),
            SizedBox(height: 10),
            TextField(
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
            TextField(
              onChanged: (val) {
                form.startDate = val;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Schedule Date',
              ),
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
              onPressed: (){},
              icon: Icon(Icons.save_alt, color: Colors.white),
              label: Text(
                  'Schedule Session',
                  style: TextStyle(
                    color: Colors.white
                  )
              ),
              color: Colors.pinkAccent,
            )
          ],
        ),
      ),
    );
  }
}

class FormData {
  List<SessionProduct> products = List<SessionProduct>();
  String name;
  String startDate;

  FormData({this.name, this.startDate, this.products});
}

