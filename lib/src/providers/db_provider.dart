import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qrscan/src/models/scan_model.dart';
export 'package:qrscan/src/models/scan_model.dart';


class DBProvider {
  
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._(); // Constructor privado DBProvider._(); es igual DBProvider._texto();

  Future<Database> get database async{

    if (_database != null) {
      return _database;      
    }

    _database = await initDB();

    return _database;

  }

  initDB() async {

    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version:1,
      onOpen: (db) {},
      onCreate: ( Database db, int version ) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      } 
      );

  }

  // CREAR REGISTROS
  nuevoScan( ScanModel nuevoScan ) async {
    
    //Metodo 1
    //final db = await database;
    //final sql = "INSERT INTO Scans (id, tipo, valor) VALUES ( ${ nuevoScan.id }, '${ nuevoScan.tipo }', '${ nuevoScan.valor }' )";
    //final res = await db.rawInsert( sql );
    //return res;

    //Metodo 2
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }


  // OBTENER REGISTROS
  Future<ScanModel> getScanId( int id ) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.query('Scans');
    List<ScanModel> list = res.isNotEmpty 
                            ? res.map((c) => ScanModel.fromJson(c)).toList() 
                            : [];
    return list;
  }

  Future<List<ScanModel>> getTypeScans( String type ) async {
    final db = await database;
    //final res = await db.query('Scans', where: "tipo = ?", whereArgs: [type]); 
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$type'"); //Otra opcion
    List<ScanModel> list = res.isNotEmpty 
                            ? res.map((c) => ScanModel.fromJson(c)).toList() 
                            : [];
    return list;
  }


  // ACTUALIZAR REGISTROS
  Future<int> updateScann( ScanModel nuevoScan ) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  // ELIMINAR REGISTROS
  Future<int> deleteScann( int id ) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }


}

  
