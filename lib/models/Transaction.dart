class TransactionModel {
  int id;
  int session_id;
  int user_id;
  double amount;
  String createdDate;
  bool payType;

  TransactionModel({this.id, this.session_id, this.user_id, this.amount, this.payType, this.createdDate});
}