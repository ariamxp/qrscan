import 'package:flutter/material.dart';
import 'package:qrscan/src/bloc/scans_bloc.dart';
import 'package:qrscan/src/models/scan_model.dart';
import 'package:qrscan/src/utils/open_url_util.dart';

class DireccionesPage extends StatelessWidget {
  
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {  
    
    scansBloc.obtenerScans();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: StreamBuilder(
        stream: scansBloc.scansStreamHttp,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          
          if ( !snapshot.hasData ) {
            return Center(child: CircularProgressIndicator(),);
          }

          final scans = snapshot.data;

          if ( scans.length == 0 ) {
            return Center(
              child: Text("No hay información"),
            );
          }
          
          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red ,),
                onDismissed: (direction) => scansBloc.borrarScans(scans[i].id),
                child: ListTile(
                leading: Icon(Icons.link, color: Theme.of(context).primaryColor,),
                title: Text(scans[i].valor),
                subtitle: Text(scans[i].tipo),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                    abrirURL(context,scans[i]);
                },
              ),
            ),
          );

        },
      ),
    );

    
  }

  
}