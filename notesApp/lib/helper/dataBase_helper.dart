import 'note_Class.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper {
  //singleton which means rund only once
  static DatabaseHelper _databaseHelper;
  static Database _database;
  // TODO: creating var for table inside sql
  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
  String colPriority = 'priority';
  // TODO: creating instance so that database is created which has named constructor
  DatabaseHelper._createInstance();

  // TODO: create dataBase once and add data in single database by
  // singleton method which runs only once

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  // custom getter for initiliser of DB
  Future<Database> get database async {
    if (_database == null) {
      _database = await initalizerdatabase();
    }
    return _database;
  }

  // TODO: initialising of database in future
  // so that main thread will be free and this runs async
  Future<Database> initalizerdatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var notesDatabase = await openDatabase(
      path,
      onCreate: _createDb, //query method is called
      version: 1,
    );
    return notesDatabase;
  }

  // TODO: method which makes queries in sql
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)'); //QUERY TO CREATE DATA IN DB
  }

  // TODO: now database is creeated & now method for data going inside DB to store

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(noteTable, orderBy: '$colPriority ASC');
    return result;
  }

//  TODO: crud operation in which Read & Update & Delete are made as method
// inserting data in DB
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

// updating data in DB
  Future<int> updatetNote(Note note) async {
    Database db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

// Deleting data in DB for this id is enough so that it is easy to delete data
  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable where $colId = $id');
    return result;
  }

  // TODO: converting map list into note list in DB

  // to get count of no.of note it can be displayed to the user

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();

    int count = noteMapList.length;

    List<Note> noteList = new List<Note>();
    for (var i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}
