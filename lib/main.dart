import 'package:flutter/material.dart';
import 'package:qrscan/src/pages/home_page.dart';
import 'package:qrscan/src/pages/mapa_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR App',
      initialRoute: 'home',
      routes: {
        'home'    :   (BuildContext context) => HomePage(),
        'mapa'    :   (BuildContext context) => MapaPage()
      },
      theme: ThemeData(
        primaryColor: Colors.amber,
        buttonColor: Colors.black,
      ),
    );
  }
}