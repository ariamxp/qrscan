import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:qrscan/src/models/scan_model.dart';
import 'package:flutter_map/flutter_map.dart';


class MapaPage extends StatefulWidget {
  MapaPage({Key key}) : super(key: key);

  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {

  final map = new MapController();
  String tipoMapa = 'dark';
  double zoomMapa = 15;

  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("Mapa QR"),
           actions: <Widget>[
             IconButton(
               icon: Icon(Icons.zoom_in),
               onPressed: (){
                 setState(() {
                   zoomMapa++;
                   map.move(scan.getLatLong(), zoomMapa);
                 });
               },
             ),
             IconButton(
               icon: Icon(Icons.zoom_out),
               onPressed: (){
                 setState(() {
                   zoomMapa--;
                   map.move(scan.getLatLong(), zoomMapa);
                 });
               },
             ),
             IconButton(
               icon: Icon(Icons.my_location),
               onPressed: (){
                 zoomMapa=15;
                 map.move(scan.getLatLong(), zoomMapa);
               },
             )
           ],
         ),
         body: _crearFlutterMap(scan),
         floatingActionButton: _crearBotonFlotante(context),
         floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ) 
    );
  }

  Widget _crearFlutterMap(ScanModel scan) {

    return FlutterMap(
      mapController: map,
      options: MapOptions(
        center: scan.getLatLong(),
        zoom: zoomMapa
      ),
      layers: [
        _crearMapa(),
        _crearMarcadores(scan)
      ],
    );

  }

  _crearMapa() {

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
      additionalOptions: {
        'accessToken' : 'pk.eyJ1IjoiYXJpYW14cCIsImEiOiJjazQyd2Z1OWcwMW5qM2RxbDJrOWozNWNyIn0.Qx_5QQkWHtvwyi_HI0UzDw',
        'id'          : 'mapbox.$tipoMapa'
        // streets, dark, light, outdoors, satellite
      }
    );

  }

  _crearMarcadores(ScanModel scan) {

    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLong(),
          builder: ( context ) => Container(
            child: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
              size: 60.0,
            ),
          )
        )
      ]
    );

  }

  Widget _crearBotonFlotante(BuildContext context) {

    return FloatingActionButton(
      child: Icon(Icons.shuffle),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){

        setState(() {
          if (tipoMapa == 'dark') {
            tipoMapa = 'streets';
          } else if(tipoMapa == 'streets'){
            tipoMapa = 'light';
          }else if(tipoMapa == 'light'){
            tipoMapa = 'outdoors';
          }else if(tipoMapa == 'outdoors'){
            tipoMapa = 'satellite';
          }else if(tipoMapa == 'satellite'){
            tipoMapa = 'dark';
          }
        });
      }, 

    );
    
  }

}

