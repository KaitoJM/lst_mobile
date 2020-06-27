import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/globals.dart';

class OrdersData {
  Future<Map> submitOrder(int sessionId, int customerId, String customerName, String customerLName, String email, String phone, String address, int gender, int userId, orderItemsJson) async {
    print('Submiting Order...');
    Response response = await post('${global.api_url}submit-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_id': sessionId,
          'customer_id': customerId,
          'customer_fname': customerName,
          'customer_lname': customerLName,
          'customer_email': email,
          'customer_phone': phone,
          'customer_address': address,
          'customer_gender': gender,
          'author_id': userId,
          'items': orderItemsJson
        })
    );
    print('Submit order finished.');

    return json.decode(response.body);
  }

  Future<Map> updateOrder(int orderId, String formItems) async {
    print('Updating order...');
    Response response = await post('${global.api_url}update-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'order_id': orderId,
          'items': formItems
        })
    );
    print('Update order finished.');

    return json.decode(response.body);
  }

  Future<Map> deleteOrderResponse({int order_id}) async {
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

  Future<Map> payOrderResponse(int order_id) async {
    print('Setting up payment...');
    Response response = await post('${global.api_url}pay-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'order_id': order_id
        })
    );
    print('Paid order function finished.');

    return  json.decode(response.body);
  }

  Future<Map> unpayOrderResponse(int order_id) async {
    print('Rollback payment...');
    Response response = await post('${global.api_url}pay-order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'order_id': order_id
        })
    );
    print('Payment rollback function finished.');

    return  json.decode(response.body);
  }
}