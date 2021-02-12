import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter_api/produto.dart';

class AlertDialogCustomizado extends StatelessWidget {
  var controllerNome = TextEditingController();
  var controllerQuantidade = TextEditingController();
  var controllerValidade = TextEditingController();

  adicionarProduto(String nome, String quantidade, String validade) {
    Produto produto = Produto();
    produto.nome = nome;
    produto.quantidade = quantidade;
    produto.validade = validade;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("produtos").add(produto.toMap());
  }

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
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: controllerValidade,
              decoration: InputDecoration(
                labelText: "Validade",
              ),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
            child: Text("Adicionar"),
            onPressed: () {
              adicionarProduto(
                controllerNome.text,
                controllerQuantidade.text,
                controllerValidade.text,
              );
            }),
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
