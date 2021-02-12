import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdutosCadastrados extends StatefulWidget {
  @override
  _ProdutosCadastradosState createState() => _ProdutosCadastradosState();
}

class _ProdutosCadastradosState extends State<ProdutosCadastrados> {
  final controllerListaProdutos = StreamController<QuerySnapshot>.broadcast();

  Stream<QuerySnapshot> adicionarListenerProdutos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final stream = db.collection("produtos").snapshots();

    stream.listen((dados) {
      controllerListaProdutos.add(dados);
    });
  }

  @override
  void initState() {
    adicionarListenerProdutos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      body: Container(),
    );
  }
}
