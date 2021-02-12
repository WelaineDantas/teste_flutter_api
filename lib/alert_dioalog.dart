import 'package:flutter/material.dart';

class AlertDialogCustomizado extends StatelessWidget {
  var controllerNome = TextEditingController();
  var controllerQuantidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Adicionar produto"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controllerNome,
            decoration: InputDecoration(
              labelText: "Nome",
            ),
          ),
          TextField(
            controller: controllerQuantidade,
            decoration: InputDecoration(
              labelText: "Quantidade",
            ),
          )
        ],
      ),
    );
  }
}
