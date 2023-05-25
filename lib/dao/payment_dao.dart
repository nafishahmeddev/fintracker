import 'dart:async';
import 'package:fintracker/dao/account_dao.dart';
import 'package:fintracker/dao/category_dao.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/account.model.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:fintracker/model/payment.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class PaymentDao {
  Future<int> create(Payment payment) async {
    final db = await getDBInstance();
    var result = db.insert("payments", payment.toJson());
    return result;
  }

  Future<List<Payment>> find({
    DateTimeRange? range,
    PaymentType? type,
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
      where += "AND type='${type == PaymentType.credit?"DR":"CR"}' ";
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


    List<Payment> payments = [];
    List<Map<String, Object?>> rows =  await db.query(
        "payments",
        orderBy: "datetime DESC, id DESC",
        where: "1=1 $where"
    );
    for (var row in rows) {
      Map<String, dynamic> payment = Map<String, dynamic>.from(row);
      Account account = accounts.firstWhere((a) => a.id == payment["account"]);
      Category category = categories.firstWhere((c) => c.id == payment["category"]);
      payment["category"] = category.toJson();
      payment["account"] = account.toJson();
      payments.add(Payment.fromJson(payment));
    }

    return payments;
  }

  Future<int> update(Payment payment) async {
    final db = await getDBInstance();

    var result = await db.update("payments", payment.toJson(), where: "id = ?", whereArgs: [payment.id]);

    return result;
  }

  Future<int> upsert(Payment payment) async {
    final db = await getDBInstance();
    int result;
    if(payment.id != null) {
      result = await db.update(
          "payments", payment.toJson(), where: "id = ?",
          whereArgs: [payment.id]);
    } else {
      result = await db.insert("payments", payment.toJson());
    }

    return result;
  }


  Future<int> deleteTransaction(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("payments", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future deleteAllTransactions() async {
    final db = await getDBInstance();
    var result = await db.delete(
      "payments",
    );
    return result;
  }
}