class ClienteModel {
  int? id;
  String nome;
  String telefone;
  DateTime? createdAt;

  ClienteModel({
    this.id,
    required this.nome,
    required this.telefone,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory ClienteModel.fromMap(Map<String, dynamic> map) {
    return ClienteModel(
      id: map['id'],
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }
}