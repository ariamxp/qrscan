import 'package:flutter/material.dart';
import 'package:qrscan/src/providers/db_provider.dart';
import 'package:url_launcher/url_launcher.dart';

abrirURL(BuildContext context, ScanModel scan ) async {

    if (scan.tipo == 'http') {
      final url = scan.valor;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }else{
      
      Navigator.pushNamed(context, 'mapa', arguments: scan);

    }
  }