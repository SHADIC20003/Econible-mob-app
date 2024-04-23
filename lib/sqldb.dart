import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb{

  static Database? _db;

  Future<Database?> get db async {  //we use this function to initialize the database one time only 
    if (_db ==null){
      _db = await initialDb();
      return _db;
    }else{
      return _db;
    }
  }

  initialDb() async{
    String databasepath = await getDatabasesPath(); //this initializes the path to save the database in the phone automatically
    String path = join(databasepath,'wael.db');//we create a database called wael.db to in that path
    Database mydb = await openDatabase(path,onCreate: _onCreate ,version: 1,onUpgrade: _onUpgrade  );//we open the database 
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion ) async {
    /*await db.execute('''
          ALTER TABLE users ADD COLUMN name TEXT
        
      ''');
    print("on upgrade ================================");*/
  }

  _onCreate(Database db, int version) async{//this fucntion we use to create the tables of the database 
      await db.execute('''
          CREATE TABLE 'users'(
              'userID' INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
              'userName' TEXT NOT NULL,
              'email' TEXT NOT NULL,
              'password'   TEXT NOT NULL
            )
        
      ''');

        /*await db.execute('''
            CREATE TABLE "notes"(
              id INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY ,
              notes TEXT NOT NULL 
            )
        
      )''');*/
      print("create DATEBASE AND TABLE ========================");
  }

//select
readData(String sql) async{
  Database? mydb = await db;
  List<Map> response = await mydb!.rawQuery(sql);//we add await to future type functions also the ! is added to the name becasue we cant use methods with datatypes that accept null so we add ! to sole the error 
  return response;
}

//insert 
insertData(String sql) async{
  Database? mydb = await db;
  int response = await mydb!.rawInsert(sql);//insert return integer 
  return response;
}

//update
updateData(String sql) async{
  Database? mydb = await db;
  int response = await mydb!.rawUpdate(sql); 
  return response;
}

//deleteData
deleteData(String sql) async{
  Database? mydb = await db;
  int response = await mydb!.rawDelete(sql);
  return response;
}

//delete database 
mydeleteDatabase()async{
   String databasepath = await getDatabasesPath(); //this initializes the path to save the database in the phone automatically
  String path = join(databasepath,'wael.db');//we create a database called wael.db to in that path
  await deleteDatabase(path);

  print("database deleted=====================");

}



}