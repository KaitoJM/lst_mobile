import 'package:flutter/material.dart';
import 'package:lifesweettreatsordernotes/models/product.dart';
import 'package:lifesweettreatsordernotes/requests/products.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Products extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Products> {
  List<Product> products = List<Product>();
  bool loaded_products = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomer();
  }

  void getCustomer() async {
    products = await ProductsData().getProducts();
    setState(() {
      products = products;
      loaded_products = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0.0,
      ),
      body: (loaded_products) ? Container(
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
          children: products.map((Product product) {
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
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('₱${product.price}',
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                        Icon(Icons.edit, size: 18),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.fastfood, size: 40),
                      Text('${product.name}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14
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
