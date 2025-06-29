import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class taskDBHelper{
   taskDBHelper._();
   static final taskDBHelper getInctance = taskDBHelper._();
   static const String TABLE_TASK = "task_table";
   static const String COLUMN_S_NO = "s_no";
   static const String COLUMN_TASK = "task";
   static const String COLUMN_IS_SELECTED = "isSelected";


   Database? taskDB;
   Future<Database>getDB()async{
     if(taskDB != null){
       return taskDB!;
     }
     else{
       taskDB = await openDB();
       return taskDB!;
     }
   }
   Future<Database> openDB() async {
     Directory appDirectory = await getApplicationDocumentsDirectory();
     String dbPath = join(appDirectory.path, "taskDB.db");

     // Delete the old DB — for development/debugging
     // await deleteDatabase(dbPath);

     return await openDatabase(
       dbPath,
       version: 1,
       onCreate: (db, version) async {
         print("Creating DB...");
         await db.execute('''
  CREATE TABLE $TABLE_TASK (
    $COLUMN_S_NO INTEGER PRIMARY KEY AUTOINCREMENT,
    $COLUMN_TASK TEXT,
    $COLUMN_IS_SELECTED INTEGER NOT NULL DEFAULT 0
  )
''');

       },
       onOpen: (db) {
         print("DB opened at path: $dbPath");
       },
     );
   }


   Future<bool> addTask({required String mTask, required bool mselected}) async {
     final db = await getDB();

     int rowsEffected = await db.insert(
       TABLE_TASK,
       {
         COLUMN_TASK: mTask,
         COLUMN_IS_SELECTED: mselected ? 1 : 0,
       },
     );

     print("Task added: $mTask");
     return rowsEffected > 0;
   }


   Future<List<Map<String,dynamic>>> getAllTask()async{
     var db=await getDB();
     List<Map<String,dynamic>> mData=await db.query(TABLE_TASK);
     return mData;
   }
   Future<bool> toggleSelectedTask({required int sno, required bool isSelected}) async {
     final db = await getDB();
     int rowsEffected = await db.update(
       TABLE_TASK,
       {
         COLUMN_IS_SELECTED: isSelected ? 1 : 0,
       },
       where: "$COLUMN_S_NO = ?",
       whereArgs: [sno],
     );
     return rowsEffected > 0;
   }

   Future<bool> deleteTask({required int sno})async{
     var db=await getDB();
     int rowsEffected = await db.delete(TABLE_TASK,where: "$COLUMN_S_NO=?",whereArgs: [sno],);
     return rowsEffected>0;
   }

   Future<int>countCompletedTask()async{
     final db=await getDB();
     final result=await db.rawQuery('select count(*) from $TABLE_TASK where $COLUMN_IS_SELECTED=1');
     return Sqflite.firstIntValue(result) ?? 0;
   }

   Future<int>countPendingTask()async{
     final db=await getDB();
     final result=await db.rawQuery('select count(*) from $TABLE_TASK where $COLUMN_IS_SELECTED=0');
     return Sqflite.firstIntValue(result) ?? 0;
   }

}