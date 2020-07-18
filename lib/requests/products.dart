import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/product.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class ProductsData {
  Future<List<Product>> getProducts() async {
    print('Loading Products...');
    Response responseProduct = await get('${global.api_url}get-products');
    print('Loaded Products');
    List<dynamic> productArray = json.decode(responseProduct.body);
    List<Product> product_temp = List<Product>();

    productArray.forEach((product) {
      product_temp.add(new Product(
          id: product['id'],
          name: product['name'],
          price: product['price'].toDouble(),
          image: product['image'],
          categoryId: product['category_id']
      ));
    });

    return product_temp;
  }
}