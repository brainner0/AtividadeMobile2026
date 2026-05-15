class UsuarioModel {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String createdAt;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.createdAt,
  });

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      createdAt: map['createdAt'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'createdAt': createdAt,
    };
  }
}