class TecnicoModel {
  final int? id;
  final String nome;
  final String email;
  final String telefone;
  final String especialidade;
  final String dataCriacao;

  TecnicoModel({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.especialidade,
    required this.dataCriacao,
  });

  factory TecnicoModel.fromMap(Map<String, dynamic> map) {
    return TecnicoModel(
      id: map['id'] as int?,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'] ?? '',
      especialidade: map['especialidade'] ?? '',
      dataCriacao: map['dataCriacao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'especialidade': especialidade,
      'dataCriacao': dataCriacao,
    };
  }
}