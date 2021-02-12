class Produto {
  String _nome;
  String _quantidade;
  String _validade;

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

  String get quantidade => _quantidade;

  set quantidade(String value) {
    _quantidade = value;
  }

  String get validade => _validade;

  set validade(String value) {
    _validade = value;
  }
}
