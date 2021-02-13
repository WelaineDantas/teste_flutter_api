import 'package:flutter/material.dart';
import 'package:teste_flutter_api/widget/alert_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      null,
      AlertDialogCustomizado(),
      null,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Estoque"),
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: ListTile(
            leading: Icon(Icons.arrow_forward_ios_rounded),
            title: Text("Produtos Cadastrados"),
            onTap: () => Navigator.pushNamed(context, "PRODUTOSCADASTRADOS"),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        currentIndex: _indiceAtual,
        fixedColor: Colors.white,
        onTap: (indice) {
          setState(() {
            _indiceAtual = indice;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Início",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.error_outline_rounded),
            label: "Adicionar item",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: "Itens Vencidos",
          ),
        ],
      ),
    );
  }
}
