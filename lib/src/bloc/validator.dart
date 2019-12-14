

import 'dart:async';
import 'dart:math';

import 'package:qrscan/src/providers/db_provider.dart';

class Validator {
  
  final validadorGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ){

      final geoScans = scans.where((s) => s.tipo == 'geo').toList();
      sink.add(geoScans);

    }
  );

  final validadorHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: ( scans, sink ){

      final httpScans = scans.where((s) => s.tipo == 'http').toList();
      sink.add(httpScans);

    }
  );

}