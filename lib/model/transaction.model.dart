import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:intl/intl.dart';

enum TransactionType {
  debit,
  credit
}
class Transaction {
  int? id;
  Account account;
  Category category;
  double amount;
  TransactionType type;
  DateTime datetime;
  String title;
  String description;

  Transaction({
    this.id,
    required this.account,
    required this.category,
    required this.amount,
    required this.type,
    required this.datetime,
    required this.title,
    required this.description
  });


  factory Transaction.fromJson(Map<String, dynamic> data) {
    return Transaction(
      id: data["id"],
      title: data["title"] ??"",
      description: data["description"]??"",
      account: Account.fromJson(data["account"]),
      category: Category.fromJson(data["category"]),
      amount: data["amount"],
      type: data["type"] == "CR" ? TransactionType.credit : TransactionType
          .debit,
      datetime: DateTime.parse(data["datetime"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "account": account.id,
    "category": category.id,
    "amount": amount,
    "datetime": DateFormat('yyyy-MM-dd kk:mm:ss').format(datetime),
    "type": type == TransactionType.credit ? "CR": "DR",
  };
}