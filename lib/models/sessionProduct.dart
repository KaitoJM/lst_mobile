class SessionProduct {
  int id;
  String productName;
  int productId;
  double price;
  int qty;

  SessionProduct({this.id, this.productName, this.productId, this.price, this.qty});

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