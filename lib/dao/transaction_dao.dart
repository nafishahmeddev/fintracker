import 'dart:async';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/category_dao.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/transaction.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TransactionDao {
  Future<int> create(Transaction transaction) async {
    final db = await getDBInstance();
    var result = db.insert("transactions", transaction.toJson());
    return result;
  }

  Future<List<Transaction>> find({
    DateTimeRange? range,
    TransactionType? type,
    Category? category,
    Account? account
}) async {
    final db = await getDBInstance();
    String where = "";

    if(range!=null){
      where += "AND datetime BETWEEN DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.start)}') AND DATE('${DateFormat('yyyy-MM-dd kk:mm:ss').format(range.end.add(const Duration(days: 1)))}')";
    }

    //type check
    if(type != null){
      where += "AND type='${type == TransactionType.credit?"DR":"CR"}' ";
    }

    //icon check
    if(account != null){
      where += "AND account='${account.id}' ";
    }

    //icon check
    if(category != null){
      where += "AND category='${category.id}' ";
    }

    //categories
    List<Category> categories = await CategoryDao().find();
    List<Account> accounts = await AccountDao().find();


    List<Transaction> transactions = [];
    List<Map<String, Object?>> rows =  await db.query(
        "transactions",
        orderBy: "datetime DESC, id DESC",
        where: "1=1 $where"
    );
    for (var row in rows) {
      Map<String, dynamic> transaction = Map<String, dynamic>.from(row);
      Account account = accounts.firstWhere((a) => a.id == transaction["account"]);
      Category category = categories.firstWhere((c) => c.id == transaction["category"]);
      transaction["category"] = category.toJson();
      transaction["account"] = account.toJson();
      transactions.add(Transaction.fromJson(transaction));
    }

    return transactions;
  }

  Future<int> update(Transaction transaction) async {
    final db = await getDBInstance();

    var result = await db.update("transactions", transaction.toJson(), where: "id = ?", whereArgs: [transaction.id]);

    return result;
  }

  Future<int> upsert(Transaction transaction) async {
    final db = await getDBInstance();
    int result;
    if(transaction.id != null) {
      result = await db.update(
          "transactions", transaction.toJson(), where: "id = ?",
          whereArgs: [transaction.id]);
    } else {
      result = await db.insert("transactions", transaction.toJson());
    }

    return result;
  }


  Future<int> deleteTransaction(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("transactions", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future deleteAllTransactions() async {
    final db = await getDBInstance();
    var result = await db.delete(
      "transactions",
    );
    return result;
  }
}