import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter_api/model/produto.dart';

class ProdutosCadastrados extends StatefulWidget {
  @override
  _ProdutosCadastradosState createState() => _ProdutosCadastradosState();
}

class _ProdutosCadastradosState extends State<ProdutosCadastrados> {
  final controllerListaProdutos = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String produtoSelecionado = "----";
  bool produtoBool = false;
  String id;
  String nome;
  String quantidade;
  String validade;

  Stream<QuerySnapshot> adicionarListenerProdutos() {
    final stream = db.collection("produtos").snapshots();

    stream.listen((dados) {
      controllerListaProdutos.add(dados);
    });
  }

  Future<Produto> recuperarDadosProduto({String idProduto}) async {
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

  atualizarDadosProduto(String nome, String quantidade, String validade) {
    db.collection("produtos").doc(id).update({
      "nome": nome,
      "quantidade": quantidade,
      "validade": validade,
    });
  }

  deletarProduto() {
    db.collection("produtos").doc(id).delete();
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
                                //id = item.id;

                                return ListTile(
                                  title: Text(produto),
                                  selected: produto == produtoSelecionado,
                                  onTap: () {
                                    setState(() {
                                      id = item.id;
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
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "   Quantidade: $quantidade",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Divider(),
                          Text(
                            "   Validade: $validade",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
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
                                title: Text("Editar Produto"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      onChanged: (value) => nome = value,
                                      initialValue: nome,
                                      decoration: InputDecoration(
                                        labelText: "Nome",
                                      ),
                                    ),
                                    TextFormField(
                                      onChanged: (value) => quantidade = value,
                                      initialValue: quantidade,
                                      decoration: InputDecoration(
                                          labelText: "Quantidade"),
                                    ),
                                    TextFormField(
                                      onChanged: (value) => validade = value,
                                      initialValue: validade,
                                      decoration: InputDecoration(
                                          labelText: "Validade"),
                                      //onChanged: ,
                                    )
                                  ],
                                ),
                                actions: [
                                  FlatButton(
                                      child: Text("Atualizar"),
                                      onPressed: () {
                                        atualizarDadosProduto(
                                            nome, quantidade, validade);
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                    child: Text("Cancelar"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
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
                    onPressed: deletarProduto,
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
