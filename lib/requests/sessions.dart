import 'package:http/http.dart';
import 'dart:convert';

import 'package:lifesweettreatsordernotes/models/sessionType.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/models/order.dart';
import 'package:lifesweettreatsordernotes/models/orderItem.dart';

import 'package:lifesweettreatsordernotes/globals.dart';

class SessionsData {
  Future<Session> currentSession({current_recommended: false}) async {
    print('Loading Current Session...');
    String url = '${global.api_url}get-current-session';

    if (current_recommended) {
      url = '${global.api_url}get-current-session/current-only';
    }

    Response response = await get(url);
    if (response.statusCode == 200) {
      print('Loaded Current Session');

      if (json.decode(response.body).length > 0) {
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
                    sessionProductId: item['session_product_id'],
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
              status: order['status'],
              items: items
          ));
        });

        List<dynamic> productArray = session_map['products'];
        List<SessionProduct> products = List<SessionProduct>();

        productArray.forEach((product) {
          products.add(new SessionProduct(
            id: product['id'],
            productName: product['product'],
            productId: product['product_id'],
            price: product['price'].toDouble(),
            qty: product['qty'],
            totalOrderQty: product['total_order_qty'],
            totalOrderQtyOrdered: product['total_order_qty_ordered'],
            totalOrderQtyPaid: product['total_order_qty_paid'],
            totalOrderAmount: product['total_order_amount'].toDouble(),
            totalOrderOrdered: product['total_order_ordered'].toDouble(),
            totalOrderPaid: product['total_order_paid'].toDouble(),
          ));
        });

        return Session(id: session_map['id'], name: session_map['name'], startDate: session_map['start_date'], endDate: session_map['end_date'], status: session_map['status'], orders: orders, products: products);
      } else {
        return Session(name: '', startDate: '', orders: List<Order>(), products: List<SessionProduct>());
      }
    } else {
      print('${response.statusCode}: A network error occurred');
      return Session(name: '', startDate: '', orders: List<Order>(), products: List<SessionProduct>());
    }

  }

  Future<SessionType> allSessions() async {
    print('Loading Sessions...');
    Response response = await get('${global.api_url}get-sessions');
    print('Loaded Sessions');

    Map sessions_map = json.decode(response.body);

    List<dynamic> sessionPending = sessions_map['preparation'];
    List<dynamic> sessionEnded = sessions_map['ended'];

    print(sessionPending);
    print(sessionEnded  );

    List<dynamic> sessionPendingLists = sessionPending;
    List<dynamic> sessionEndedLists = sessionEnded;

    List<Session> pending_temp = List<Session>();
    sessionPendingLists.forEach((element) {
      List<SessionProduct> products = List<SessionProduct>();
      List<dynamic> prodList = element['products'];

      prodList.forEach((prod) {
        products.add(
            SessionProduct(
                id: prod['id'],
                productName: prod['product'],
                price: prod['price'].toDouble(),
                productId: prod['product_id'],
                qty: (prod['qty'] != null) ? prod['qty'] : 0
            )
        );
      });

      List<dynamic> orderArray = element['orders'];
      List<Order> orders = List<Order>();

      orderArray.forEach((order) {
        orders.add(
          Order(
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
            status: order['status']
          )
        );
      });

      pending_temp.add(
          Session(
              id: element['id'],
              name: element['name'],
              startDate: element['start_date'],
              endDate: element['end_date'],
              status: element['status'],
              products: products,
              orders: orders
          )
      );
    });

    List<Session> ended_temp = List<Session>();
    sessionEndedLists.forEach((element) {
      List<dynamic> orderArray = element['orders'];
      List<Order> orders = List<Order>();

      orderArray.forEach((order) {
        orders.add(
            Order(
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
                status: order['status']
            )
        );
      });

      ended_temp.add(
          Session(
              id: element['id'],
              name: element['name'],
              startDate: element['start_date'],
              endDate: element['end_date'],
              status: element['status'],
              expense: element['expense'].toDouble(),
              orders: orders
          )
      );
    });

    return SessionType(preparations: pending_temp, history: ended_temp);
  }

  Future<Map> CloseSessionResponse({int session_id}) async {
    print('Closing session...');
    Response response = await post('${global.api_url}close-session',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_id': session_id
        })
    );
    print('Completed session close action.');

    return json.decode(response.body);
  }

  Future<Map> OpenSessionRespose({int session_id}) async {
    print('Opening session...');
    Response response = await post('${global.api_url}open-session',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_id': session_id
        })
    );
    print('Completed session open action.');

    return json.decode(response.body);
  }

  Future<Map> DeleteSessionRespose({int session_id}) async {
    Response response = await post('${global.api_url}delete-session',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_id': session_id
        })
    );

    return json.decode(response.body);
  }

  Future<List<SessionProduct>> getSessionProducts(int sessionId) async {
    print('Loading session products...');
    Response response = await get('${global.api_url}get-sessions-products/${sessionId}');
    print('Loaded session products');

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

    return option_temp;
  }

  Future<Session> getSessionByProduct(int session_id, int user_id) async {
    print('Loading session details...');
    Response response = await post('${global.api_url}get-session-by-product',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'session_id': session_id,
          'user_id': user_id
        })
    );
    print('Fetching session details done.');

    Map session_map = json.decode(response.body);

    print(session_map);

    if (session_map['session'] != null) {
      List products = session_map['session']['products'];
      List<SessionProduct> sessionProducts = List<SessionProduct>();

      products.forEach((prod) {
        List<OrderItem> orderItems = List<OrderItem>();
        List items = prod['order_items'];

        items.forEach((item) {
          Order order = Order(
            id: item['order']['id'],
            sessionId: item['order']['session_id'],
            customerId: item['order']['customer_id'],
            customerLName: item['order']['customer']['lname'],
            customerFName: item['order']['customer']['fname'],
            status: item['order']['status']
          );

          orderItems.add(
            OrderItem(
              id: item['id'],
              price: item['price'].toDouble(),
              sessionProductId: prod['id'],
              productId: item['product_id'],
              productName: prod['product']['name'],
              qty: item['qty'],
              order: order
//              total: item['qty'] * prod['id'].toDouble()
            )
          );
        });

        sessionProducts.add(
          SessionProduct(
            id: prod['id'],
            productName: prod['product']['name'],
            productId: prod['product_id'],
            price: prod['product']['price'].toDouble(),
            qty: prod['quantity'],
            orderItems: orderItems
          )
        );
      });

      return Session(
        id: session_map['session']['id'],
        name: session_map['session']['name'],
        startDate: session_map['session']['start_date'],
        endDate: session_map['session']['end_date'],
        expense: session_map['session']['expense'].toDouble(),
        products: sessionProducts
      );
    } else {
      return Session(name: '', startDate: '', orders: List<Order>(), products: List<SessionProduct>());
    }
  }

  Future <List<Session>> getDeliveries() async {
    print('Loading deliveries...');
    Response response = await get('${global.api_url}deliveries');
    print('Fetching deliveries done.');

    List<Session> sessions = List<Session>();
    Map responseData = json.decode(response.body);

    print(responseData);

    if (responseData['deliveries'] != null) {
      List sessionsList = responseData['deliveries'];

      if (sessionsList.length > 0) {
        sessionsList.forEach((returnMap) {
          List products = returnMap['session']['products'];
          List<SessionProduct> sessionProducts = List<SessionProduct>();

          products.forEach((prod) {
            List<OrderItem> orderItems = List<OrderItem>();
            List items = prod['order_items'];

            items.forEach((item) {
              Order order = Order(
                  id: item['order']['id'],
                  sessionId: item['order']['session_id'],
                  customerId: item['order']['customer_id'],
                  customerLName: item['order']['customer']['lname'],
                  customerFName: item['order']['customer']['fname'],
                  status: item['order']['status']
              );

              orderItems.add(
                  OrderItem(
                      id: item['id'],
                      price: item['price'].toDouble(),
                      sessionProductId: prod['id'],
                      productId: item['product_id'],
                      productName: prod['product']['name'],
                      qty: item['qty'],
                      order: order
//              total: item['qty'] * prod['id'].toDouble()
                  )
              );
            });

            sessionProducts.add(
                SessionProduct(
                    id: prod['id'],
                    productName: prod['product']['name'],
                    productId: prod['product_id'],
                    price: prod['product']['price'].toDouble(),
                    qty: prod['quantity'],
                    orderItems: orderItems
                )
            );
          });

          sessions.add(
              Session(
                  id: returnMap['session']['id'],
                  name: returnMap['session']['name'],
                  startDate: returnMap['session']['start_date'],
                  endDate: returnMap['session']['end_date'],
                  assigneeName: '${returnMap['user']['fname']} ${returnMap['user']['lname']}',
                  products: sessionProducts
              )
          );
        });
      }

    }

    return sessions;
  }
}