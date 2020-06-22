class OrderItem {
  int id;
  String image;
  double price;
  int sessionProductId;
  int productId;
  String productName;
  int qty;
  double total;

  OrderItem({this.id, this.image, this.price, this.productId, this.productName, this.sessionProductId, this.qty, this.total});

  Map<String, dynamic> toJson(){
    return {
      "id": this.id,
      "image": this.image,
      "price": this.price,
      "session_product_id": this.sessionProductId,
      "product_id": this.productId,
      "product_name": this.productName,
      "qty": this.qty,
      "total": this.total
    };
  }
}