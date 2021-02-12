import 'package:flutter/material.dart';

class AlertDialogCustomizado extends StatelessWidget {
  var controllerNome = TextEditingController();
  var controllerQuantidade = TextEditingController();
  var controllerValidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Adicionar produto"),
      content: SingleChildScrollView(
        child: Column(
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
            ),
            TextField(
              controller: controllerValidade,
              decoration: InputDecoration(
                labelText: "Validade",
              ),
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("Adicionar"),
          onPressed: () {},
        ),
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.popAndPushNamed(context, "HOMEPAGE");
          },
        )
      ],
    );
  }
}
