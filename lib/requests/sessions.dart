import 'package:http/http.dart';
import 'dart:convert';
import 'package:lifesweettreatsordernotes/models/sessionType.dart';
import 'package:lifesweettreatsordernotes/models/session.dart';
import 'package:lifesweettreatsordernotes/models/sessionProduct.dart';
import 'package:lifesweettreatsordernotes/globals.dart';

class SessionsData {
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

      pending_temp.add(
          Session(
              id: element['id'],
              name: element['name'],
              startDate: element['start_date'],
              endDate: element['end_date'],
              status: element['status'],
              products: products
          )
      );
    });

    List<Session> ended_temp = List<Session>();
    sessionEndedLists.forEach((element) {
      ended_temp.add(
          Session(
              id: element['id'],
              name: element['name'],
              startDate: element['start_date'],
              endDate: element['end_date'],
              status: element['status']
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
}