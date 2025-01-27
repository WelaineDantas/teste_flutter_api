import 'package:flutter/material.dart';
import 'package:teste_flutter_api/pages/home_page.dart';
import 'package:teste_flutter_api/pages/produtos_cadastrados.dart';
import 'package:teste_flutter_api/pages/splash_page.dart';

class Rotas {
  static Route<dynamic> gerarRotas(RouteSettings settings) {
    switch (settings.name) {
      case "SPLASHPAGE":
        return MaterialPageRoute(
          builder: (_) => SplashPage(),
        );
      case "HOMEPAGE":
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case "PRODUTOSCADASTRADOS":
        return MaterialPageRoute(
          builder: (_) => ProdutosCadastrados(),
        );
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Erro! Tela não encontrada!"),
        ),
      );
    });
  }
}
