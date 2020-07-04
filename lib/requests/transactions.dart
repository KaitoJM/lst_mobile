import 'package:lifesweettreatsordernotes/models/orderItem.dart';
import 'package:lifesweettreatsordernotes/models/user.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/order.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class TransactionsData {
  Future<List<User>> getTransactions(int session_id) async {
    print('Loading transactions...');
    Response response = await get('${global.api_url}transactions?session_id=${session_id.toString()}');
    print('Loaded transactions');

    List user_temp = json.decode(response.body);
    List<User> users = List<User>();

    user_temp.forEach((user) {
      List orders_temp = user['orders'];
      List<Order> orders = List<Order>();

      orders_temp.forEach((order) {
        List items_temp = order['items'];
        List<OrderItem> items = List<OrderItem>();

        items_temp.forEach((item) {
          items.add(
            OrderItem(
              id: item['id'],
              price: item['price'].toDouble(),
              sessionProductId: item['session_product_id'],
              productId: item['session_product']['product_id'],
              productName: item['session_product']['product']['name'],
              qty: item['qty'],
            )
          );
        });

        orders.add(
          Order(
            id: order['id'],
            status: order['status'],
            items: items
          )
        );
      });

      users.add(
        User(
          id: user['id'],
          fname: user['fname'],
          lname: user['lname'],
          orders: orders
        )
      );
    });

    return users;
  }
}