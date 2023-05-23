import 'package:flutter/material.dart';

class Account {
  int? id;
  String name;
  String holderName;
  String accountNumber;
  IconData icon;
  Color color;
  bool? isDefault;
  double? balance;
  double? income;
  double? expense;

  Account({
    this.id,
    required this.name,
    required this.holderName,
    required this.accountNumber,
    required this.icon,
    required this.color,
    this.isDefault,
    this.income,
    this.expense,
    this.balance
  });



  factory Account.fromJson(Map<String, dynamic> data) => Account(
    id: data["id"],
    name: data["name"],
    holderName: data["holderName"] ??"",
    accountNumber: data["accountNumber"]??"",
    icon: IconData(data["icon"], fontFamily: 'MaterialIcons'),
    color: Color(data["color"]),
    isDefault: data["isDefault"]==1?true:false,
    income: data["income"],
    expense: data["expense"],
    balance: data["balance"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "holderName": holderName,
    "accountNumber": accountNumber,
    "icon": icon.codePoint,
    "color": color.value,
    "isDefault": (isDefault??false) ? 1:0
  };
}