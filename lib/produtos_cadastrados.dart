import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter_api/produto.dart';

class ProdutosCadastrados extends StatefulWidget {
  @override
  _ProdutosCadastradosState createState() => _ProdutosCadastradosState();
}

class _ProdutosCadastradosState extends State<ProdutosCadastrados> {
  final controllerListaProdutos = StreamController<QuerySnapshot>.broadcast();
  String produtoSelecionado = "----";
  bool produtoBool = false;
  String id;
  String nome;
  String quantidade;
  String validade;

  Stream<QuerySnapshot> adicionarListenerProdutos() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final stream = db.collection("produtos").snapshots();

    stream.listen((dados) {
      controllerListaProdutos.add(dados);
    });
  }

  Future<Produto> recuperarDadosProduto({String idProduto}) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("produtos").doc(idProduto).get();

    Map<String, dynamic> dados = snapshot.data();
    String nome = dados["nome"];
    String quantidade = dados["quantidade"];
    String validade = dados["validade"];

    Produto produto = Produto();
    produto.nome = nome;
    produto.quantidade = quantidade;
    produto.validade = validade;

    return produto;
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
            child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Lista de Produtos cadastrados:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 3,
                  ),
                ),
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
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
                                color: Colors.blue,
                              ),
                              itemBuilder: (context, index) {
                                List<DocumentSnapshot> produtos =
                                    querySnapshot.docs.toList();
                                DocumentSnapshot item = produtos[index];

                                String produto = item["nome"];
                                id = item.id;

                                return ListTile(
                                  title: Text(produto),
                                  selected: produto == produtoSelecionado,
                                  onTap: () {
                                    setState(() {
                                      produtoSelecionado = produto;
                                      produtoBool = true;
                                      nome = item["nome"];
                                      quantidade = item["quantidade"];
                                      validade = item["validade"];
                                    });
                                  },
                                );
                              },
                            );
                          }
                        }

                        break;
                      default:
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Produto selecionado: $produtoSelecionado",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              produtoBool
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text("Quantidade: $quantidade"),
                          Divider(),
                          Text("Validade: $validade"),
                        ],
                      ))
                  : Container(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton.extended(
                    icon: Icon(Icons.edit_rounded),
                    label: Text(
                      "Editar",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    heroTag: null,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      //controller: ,
                                      decoration: InputDecoration(
                                        labelText: "Nome",
                                      ),
                                    )
                                  ],
                                ),
                              ));
                    },
                  ),
                  FloatingActionButton.extended(
                    icon: Icon(Icons.delete),
                    label: Text(
                      "Excluir",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: Colors.red[400],
                    heroTag: null,
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
