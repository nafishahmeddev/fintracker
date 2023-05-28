import 'dart:async';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/model/category.model.dart';
import 'package:intl/intl.dart';

class CategoryDao {
  Future<int> create(Category category) async {
    final db = await getDBInstance();
    var result = db.insert("categories", category.toJson());
    return result;
  }

  Future<List<Category>> find({ bool withSummery = true }) async {
    final db = await getDBInstance();

    List<Map<String, dynamic>> result;
    if(withSummery){
      String fields = [
        "c.id","c.name","c.icon","c.color", "c.budget",
        "SUM(CASE WHEN t.type='DR' AND t.category=c.id THEN t.amount END) as expense"
      ].join(",");
      DateTime from = DateTime(DateTime.now().year, DateTime.now().month,1,0,0);
      DateTime to = DateTime.now().add(const Duration(days: 1));
      DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm");
      String sql = "SELECT $fields FROM categories c "
          "LEFT JOIN payments t ON t.category = c.id AND t.datetime BETWEEN DATE('${formatter.format(from)}') AND DATE('${formatter.format(to)}')"
          "GROUP BY c.id ";
      result = await db.rawQuery(sql);
    } else {
      result = await db.query("categories",);
    }
    List<Category> categories =[];
    if (result.isNotEmpty) {
      categories = result.map((item) => Category.fromJson(item)).toList();
    }
    return categories;
  }

  Future<int> update(Category category) async {
    final db = await getDBInstance();

    var result = await db.update("categories", category.toJson(), where: "id = ?", whereArgs: [category.id]);

    return result;
  }

  Future<int> upsert(Category category) {
    if(category.id !=null){
      return update(category);
    } else {
      return create(category);
    }
  }


  Future<int> delete(int id) async {
    final db = await getDBInstance();
    var result = await db.delete("categories", where: 'id = ?', whereArgs: [id]);
    return result;
  }

  Future deleteAll() async {
    final db = await getDBInstance();
    var result = await db.delete(
      "categories",
    );
    return result;
  }
}