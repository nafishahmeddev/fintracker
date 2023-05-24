import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

double safeDouble(dynamic value){
  try{
    return double.parse(value);
  }catch(err){
    return 0;
  }
}
void v1(Database database) async {
  debugPrint("Running first migration....");
  await database.execute("CREATE TABLE transactions ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "account INTEGER,"
      "category INTEGER,"
      "amount REAL,"
      "type TEXT,"
      "datetime DATETIME"
      ")");

  await database.execute("CREATE TABLE categories ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT,"
      "icon INTEGER,"
      "color INTEGER,"
      "type TEXT"
      ")");

  await database.execute("CREATE TABLE accounts ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "name TEXT,"
      "icon INTEGER,"
      "color INTEGER,"
      "isDefault INTEGER"
      ")");


  await database.insert("accounts", {
    "name": "Cash",
    "icon": Icons.wallet.codePoint,
    "color": Colors.teal.value,
    "isDefault": 1
  });

  //prefill all categories
  List<Map<String, dynamic>> categories = [
    {"name": "Housing", "icon": Icons.house.codePoint},
    {"name": "Transportation", "icon": Icons.emoji_transportation.codePoint},
    {"name": "Food", "icon": Icons.restaurant.codePoint},
    {"name": "Utilities", "icon": Icons.category.codePoint},
    {"name": "Insurance", "icon": Icons.health_and_safety.codePoint},
    {"name": "Medical & Healthcare", "icon": Icons.medical_information.codePoint},
    {"name": "Saving, Investing, & Debt Payments", "icon": Icons.attach_money.codePoint},
    {"name": "Personal Spending", "icon": Icons.house.codePoint},
    {"name": "Recreation & Entertainment", "icon": Icons.tv.codePoint},
    {"name": "Miscellaneous", "icon": Icons.library_books_sharp.codePoint},
  ];

  int index = 0;
  for(Map<String, dynamic> category in categories){
    await database.insert("categories", {
      "name": category["name"],
      "icon": category["icon"],
      "color": Colors.primaries[index].value,
    });
    index++;
  }



}

void v2(Database database) async {
  debugPrint("Running second migration....");
  await database.execute("ALTER TABLE accounts ADD COLUMN balance REAL NULL");

  List<Map<String, Object?>> transactions = await database.query("transactions");
  List<Map<String, Object?>> accounts = await database.query("accounts");
  for(Map<String, Object?> account in accounts){
    List<Map<String, Object?>> accountTrans = transactions.where((element) => element["account"] == account["id"]).toList();
    double debitAmount = accountTrans.fold(0, (double value, element) => value + (element["type"] == "DR"? safeDouble(element["amount"]): 0));
    double creditAmount = accountTrans.fold(0, (double value, element) => value + (element["type"] == "CR"? safeDouble(element["amount"]): 0));
    await database.execute("UPDATE accounts SET balance='${creditAmount - debitAmount}' WHERE id='${account["id"]}'");
  }
}

void v3(Database database) async {
  debugPrint("Running third migration....");
  await database.execute("ALTER TABLE transactions ADD COLUMN title TEXT NULL;");
  await database.execute("ALTER TABLE transactions ADD COLUMN description TEXT NULL;");

  await database.execute("ALTER TABLE accounts ADD COLUMN holderName TEXT NULL;");
  await database.execute("ALTER TABLE accounts ADD COLUMN accountNumber TEXT NULL;");
}

void v4(Database database) async{
  debugPrint("Running fourth migration....");
  await database.execute("ALTER TABLE categories ADD COLUMN budget REAL NULL;");
}