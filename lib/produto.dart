class Produto {
  String _nome;
  int _quantidade;
  int _validade;

  Produto();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosProduto = {
      "nome": this._nome,
      "quantidade": this._quantidade,
      "validade": this._validade,
    };

    return dadosProduto;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  int get quantidade => _quantidade;

  set quantidade(int value) {
    _quantidade = value;
  }

  int get validade => _validade;

  set validade(int value) {
    _validade = value;
  }
}
