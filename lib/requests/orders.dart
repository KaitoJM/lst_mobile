import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/order.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class OrdersData {
  Future deleteOrderResponse({int order_id}) async {
    print('Deleting order...');
    Response response = await post('${global.api_url}delete-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'order_id': order_id
        })
    );
    print('Delete order action finished.');

    return  json.decode(response.body);
  }
}