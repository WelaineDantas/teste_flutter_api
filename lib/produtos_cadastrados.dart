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
        body: SingleChildScrollView(
            child: Column(
          children: [
            Text("Lista de Produtos cadastrados:"),
            SizedBox(height: 20),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: controllerListaProdutos.stream,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Text("Carregando...");
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text("Erro ao carregar lista de produtos!");
                        } else {
                          QuerySnapshot querySnapshot = snapshot.data;
                          if (querySnapshot.docs.length == 0) {
                            return Text("Nenhum produto foi cadastrado.");
                          } else {
                            return ListView.separated(
                              itemCount: querySnapshot.docs.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 2,
                              ),
                              itemBuilder: (context, index) {
                                List<DocumentSnapshot> produtos =
                                    querySnapshot.docs.toList();
                                DocumentSnapshot item = produtos[index];

                                return ListTile();
                              },
                            );
                          }
                        }
                        break;
                      default:
                    }
                  },
                ))
          ],
        )));
  }
}
