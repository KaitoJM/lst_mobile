import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';
import 'package:lifesweettreatsordernotes/models/orderItem.dart';

class FetchCurrentSession {
  Future<Session> getData() async {
    Response response = await get('http://172.18.5.209:8080/api/get-current-session');
    Map session_map = json.decode(response.body);

    List<dynamic> orderArray = session_map['orders'];
    List<Order> orders = List<Order>();

    orderArray.forEach((order) {
      List<dynamic> itemsArrray = order['items'];
      List<OrderItem> items = List<OrderItem>();

      itemsArrray.forEach((item) {
        items.add(
            new OrderItem(
                id: item['id'],
                image: item['image'],
                price: item['price'].toDouble(), //parse to double
                productId: item['product_id'],
                productName: item['product'],
                qty: item['qty'],
                total: item['total'].toDouble()
            )
        );
      });

      orders.add(new Order(
          id: order['id'],
          authorId: order['author_id'],
          authorFName: order['author_fname'],
          authorLName: order['author_lname'],
          customerId: order['customer_id'],
          customerFName: order['customer_fname'],
          customerLName: order['customer_lname'],
          itemCount: order['items_count'],
          productCount: order['products_count'],
          total: order['total'],
          items: items
      ));
    });

    return Session(id: session_map['id'], name: session_map['name'], startDate: session_map['start_date'], orders: orders);

  }
}