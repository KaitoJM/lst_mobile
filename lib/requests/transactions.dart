import 'package:lifesweettreatsordernotes/models/Transaction.dart';
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
    print(user_temp);
    List<User> users = List<User>();

    user_temp.forEach((user) {
      List orders_temp = user['orders'];
      List<Order> orders = List<Order>();

      if (orders_temp.length > 0) {
        orders_temp.forEach((order) {
          List items_temp = order['items'];
          List<OrderItem> items = List<OrderItem>();

          if (items_temp.length > 0) {
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
          }

          orders.add(
              Order(
                  id: order['id'],
                  status: order['status'],
                  items: items
              )
          );
        });
      }

      List transaction_temp = user['transactions'];
      List<TransactionModel> transactions = List<TransactionModel>();

      transaction_temp.forEach((transaction) {
        transactions.add(
            TransactionModel(
            id: transaction['id'],
            session_id: transaction['session_id'],
            user_id: transaction['from'],
            amount: transaction['amount'].toDouble(),
            createdDate: transaction['created_at']
          )
        );
      });

      users.add(
        User(
          id: user['id'],
          fname: user['fname'],
          lname: user['lname'],
          orders: orders,
          transactions: transactions
        )
      );
    });

    return users;
  }

  Future<Map> addTransaction(int sessionId, int userId, double amount) async {
    Response response = await post('${global.api_url}add-transaction',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'session_id': sessionId,
        'user_id': userId,
        'amount': amount
      })
    );

    Map result = json.decode(response.body);

    return result;
  }
}