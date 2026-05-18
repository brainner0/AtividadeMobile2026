class ClienteModel {
  final int? id;
  final String nome;
  final String documento;
  final String email;
  final String telefone;
  final String? endereco;
  final String dataCriacao;

  ClienteModel({
    this.id,
    required this.nome,
    required this.documento,
    required this.email,
    required this.telefone,
    this.endereco,
    required this.dataCriacao,
  });

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'] as int?,
      nome: map['nome'] ?? '',
      documento: map['documento'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      endereco: map['endereco'],
      dataCriacao: map['dataCriacao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'documento': documento,
      'email': email,
      'telefone': telefone,
      'endereco': endereco,
      'dataCriacao': dataCriacao,
    };
  }
}