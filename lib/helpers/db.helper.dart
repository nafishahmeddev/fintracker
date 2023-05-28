
import "dart:io";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:fintracker/helpers/migrations/migrations.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Database? database;
Future<Database> getDBInstance() async {
  if(database == null) {
    Database db;
    if(Platform.isWindows){
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      db = await databaseFactory.openDatabase("database.db", options: OpenDatabaseOptions(
          version: 1,
          onCreate: onCreate,
          onUpgrade: onUpgrade
      ));
    } else {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, 'database.db');
      db = await openDatabase(dbPath, version: 1, onCreate: onCreate, onUpgrade: onUpgrade);
    }

    database = db;
    return db;
  } else {
    Database db = database!;
    return db;
  }
}

typedef MigrationCallback = Function(Database database);
List<MigrationCallback>migrations = [
  v1
];
void onCreate(Database database,  int version) async {
  for(MigrationCallback callback in migrations){
    await callback(database);
  }
}

void onUpgrade(Database database, int oldVersion, int version) async {
  for(int index = oldVersion; index < version; index++){
    MigrationCallback callback = migrations[index];
    await callback(database);
  }
}

Future<void> resetDatabase() async {
  Database database = await getDBInstance();
  database.delete("payments", where: "id>0");
  database.delete("accounts", where: "id>0");
  database.delete("categories", where: "id>0");

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

