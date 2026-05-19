class ServicoModel {
  final int? id;
  final String nome;
  final String descricao;
  final double valor;
  final String dataCriacao;

  ServicoModel({
    this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.dataCriacao,
  });

  factory ServicoModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ServicoModel(
      id: map['id'] as int?,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      valor: (map['valor'] ?? 0).toDouble(),
      dataCriacao: map['dataCriacao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'dataCriacao': dataCriacao,
    };
  }
}