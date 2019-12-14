import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrscan/src/bloc/scans_bloc.dart';
import 'package:qrscan/src/models/scan_model.dart';
import 'package:qrscan/src/pages/direcciones_page.dart';
import 'package:qrscan/src/pages/mapas_page.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'package:qrscan/src/utils/open_url_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _crearAppBar(),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _crearBottomNavigation(),
      floatingActionButton: _crearFloatingBottom(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _crearBottomNavigation() {

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text("Mapas")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text("Direcciones")
        )
      ],
    );

  }

  Widget _callPage(int paginaActual) {

    switch (paginaActual) {
      case 0:
        return MapasPage();
        break;
      case 1:
        return DireccionesPage();
        break;
      default:
        return MapasPage();
    } 

  }

  Widget _crearFloatingBottom() {

    return FloatingActionButton(
      child: Icon(Icons.filter_center_focus, color: Colors.black,),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: _scanQR,
    );

  }

  Widget _crearAppBar() {

    return AppBar(
      title: Text('QR Scanner'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: (){
            scansBloc.borrarScansAll();
          },
        )
      ],
    );

  }


  _scanQR() async{

    // https://avilapp.com
    // geo:40.724233047051705,-74.00731459101564

    String futureString = '';
    //String futureString = 'https://avilapp.com';

    try {
      futureString = await new QRCodeReader().scan();
    } catch (e) {
      futureString = e.toString();
    }

    if ( futureString != null ) {

      final scan = ScanModel( valor: futureString);
      scansBloc.agregarScan(scan);

      if (Platform.isIOS) {
        Future.delayed( Duration(milliseconds: 750), (){
          abrirURL(context,scan);
        });
      }else{
        abrirURL(context,scan);
      }
      
    }
    
  }

}