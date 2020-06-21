import 'package:lifesweettreatsordernotes/models/orderItem.dart';

class Order {
  int id;
  int sessionId;
  int customerId;
  String customerLName;
  String customerFName;
  int authorId;
  String authorLName;
  String authorFName;
  int deliveredBy;
  int itemCount;
  int productCount;
  int total;
  List<OrderItem> items;

  Order({this.id, this.sessionId, this.customerId, this.customerFName, this.customerLName, this.authorId, this.authorFName, this.authorLName, this.deliveredBy, this.itemCount, this.productCount, this.total, this.items});
}