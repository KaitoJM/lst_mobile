class Transaction {
  int id;
  int session_id;
  int user_id;
  double amount;
  String createdDate;

  Transaction({this.id, this.session_id, this.user_id, this.amount, this.createdDate});
}