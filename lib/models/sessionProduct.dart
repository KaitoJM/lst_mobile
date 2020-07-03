import 'package:lifesweettreatsordernotes/models/orderItem.dart';

class SessionProduct {
  int id;
  String productName;
  int productId;
  double price;
  int qty;
  int totalOrderQty;
  int totalOrderQtyOrdered;
  int totalOrderQtyPaid;
  double totalOrderAmount;
  double totalOrderOrdered;
  double totalOrderPaid;
  List<OrderItem> orderItems;

  SessionProduct({this.id, this.productName, this.productId, this.price, this.qty, this.totalOrderQty, this.totalOrderQtyOrdered, this.totalOrderQtyPaid, this.totalOrderAmount, this.totalOrderOrdered, this.totalOrderPaid, this.orderItems});

  double total() {
    double total = 0;

    if (orderItems != null) {
      orderItems.forEach((element) {
        total += element.totalComuted();
      });
    }

    return total;
  }

  double totalPaid() {
    double total = 0;

    if (orderItems != null) {
      orderItems.forEach((element) {
        if (element.order.status == 1) {
          total += element.totalComuted();
        }
      });
    }

    return total;
  }

  double totalExpected() {
    double total = 0;
    total = qty * price;
    return total;
  }

  Map<String, dynamic> toJson(){
    return {
      "id": this.id,
      "product_name": this.productName,
      "price": this.price,
      "product_id": this.productId,
      "qty": this.qty
    };
  }
}