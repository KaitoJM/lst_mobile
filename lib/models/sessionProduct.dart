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

  SessionProduct({this.id, this.productName, this.productId, this.price, this.qty, this.totalOrderQty, this.totalOrderQtyOrdered, this.totalOrderQtyPaid, this.totalOrderAmount, this.totalOrderOrdered, this.totalOrderPaid});

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