
import 'package:qrscan/src/bloc/validator.dart';
import 'package:qrscan/src/providers/db_provider.dart';
import 'dart:async';

class ScansBloc with Validator {
  
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._internal(){
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validadorGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validadorHttp);

  dispose() { 
    _scansController?.close();
  }

  obtenerScans() async{
    _scansController.sink.add( await DBProvider.db.getAllScans() );
  }

  agregarScan( ScanModel scan ) async{
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScans( int id ) async{
    await DBProvider.db.deleteScann(id);
    obtenerScans();
  }

  borrarScansAll() async{
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
  

}