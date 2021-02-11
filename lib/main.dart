import 'package:flutter/material.dart';
import 'package:teste_flutter_api/route.dart';
import 'package:teste_flutter_api/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "SPLASHPAGE",
      onGenerateRoute: Rotas.gerarRotas,
      home: SplashPage(),
    );
  }
}
