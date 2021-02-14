import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teste_flutter_api/widget/floating_action_button.dart';
import 'package:teste_flutter_api/widget/text.dart';

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
              TextCustomizado(
                text: "Lista de Produtos Cadastrados:",
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
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
                        return Center(child: CircularProgressIndicator());
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Erro ao carregar lista de produtos!"),
                          );
                        } else {
                          QuerySnapshot querySnapshot = snapshot.data;
                          if (querySnapshot.docs.length == 0) {
                            return Center(
                              child: Text("Nenhum produto foi cadastrado."),
                            );
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

                                return ListTile(
                                  title: Text(produto),
                                  selected: produto == produtoSelecionado,
                                  onTap: () {
                                    setState(
                                      () {
                                        id = item.id;
                                        produtoSelecionado = produto;
                                        produtoBool = true;
                                        nome = item["nome"];
                                        quantidade = item["quantidade"];
                                        validade = item["validade"];
                                      },
                                    );
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
              TextCustomizado(
                text: "Produto selecionado: $produtoSelecionado",
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
                          TextCustomizado(
                            text: "   Quantidade: $quantidade",
                            fontSize: 16,
                          ),
                          Divider(),
                          TextCustomizado(
                            text: "   Validade: $validade",
                            fontSize: 16,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButtonCustomizado(
                    icon: Icon(Icons.edit_rounded),
                    text: "Editar",
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
                                decoration:
                                    InputDecoration(labelText: "Quantidade"),
                                keyboardType: TextInputType.number,
                              ),
                              TextFormField(
                                onChanged: (value) => validade = value,
                                initialValue: validade,
                                decoration:
                                    InputDecoration(labelText: "Validade"),
                                keyboardType: TextInputType.datetime,
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
                              },
                            ),
                            FlatButton(
                              child: Text("Cancelar"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  FloatingActionButtonCustomizado(
                    icon: Icon(Icons.delete),
                    text: "Excluir",
                    color: Colors.red[400],
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                              "Deseja excluir o produto:  $produtoSelecionado"),
                          actions: [
                            FlatButton(
                              child: Text("Sim"),
                              onPressed: () {
                                deletarProduto();
                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Não"),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
