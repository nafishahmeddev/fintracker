
import "dart:io";
import "package:path/path.dart";
import "package:fintracker/helpers/migrations/migrations.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

 Database? database;
getDBInstance() async {
  if(database == null) {
    Database db;
    if(Platform.isWindows){
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
       db = await databaseFactory.openDatabase("main.db", options: OpenDatabaseOptions(
          version: 4,
          onCreate: onCreate,
          onUpgrade: onUpgrade
      ));
    } else {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, 'main.db');
      db = await openDatabase(dbPath, version: 4, onCreate: onCreate, onUpgrade: onUpgrade);
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
  v1, v2, v3, v4
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