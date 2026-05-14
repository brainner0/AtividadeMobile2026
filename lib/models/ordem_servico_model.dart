/// Modelo de dados para Ordem de Serviço
class OrdemServicoModel {
  final int? id;
  final String clienteNome;
  final String clienteTelefone;
  final String descricao;
  final double valor;
  final String fotoAntesPath;
  final String? fotoDepoisPath;
  final String? assinaturaPath;
  final String status; // 'em_andamento', 'finalizada'
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrdemServicoModel({
    this.id,
    required this.clienteNome,
    required this.clienteTelefone,
    required this.descricao,
    required this.valor,
    required this.fotoAntesPath,
    this.fotoDepoisPath,
    this.assinaturaPath,
    this.status = 'em_andamento',
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Converte para Map para salvar no SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clienteNome': clienteNome,
      'clienteTelefone': clienteTelefone,
      'descricao': descricao,
      'valor': valor,
      'fotoAntesPath': fotoAntesPath,
      'fotoDepoisPath': fotoDepoisPath,
      'assinaturaPath': assinaturaPath,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Cria objeto a partir do Map do SQLite
  factory OrdemServicoModel.fromMap(Map<String, dynamic> map) {
    return OrdemServicoModel(
      id: map['id'],
      clienteNome: map['clienteNome'],
      clienteTelefone: map['clienteTelefone'],
      descricao: map['descricao'],
      valor: map['valor'],
      fotoAntesPath: map['fotoAntesPath'],
      fotoDepoisPath: map['fotoDepoisPath'],
      assinaturaPath: map['assinaturaPath'],
      status: map['status'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Cria uma cópia com campos atualizados
  OrdemServicoModel copyWith({
    int? id,
    String? clienteNome,
    String? clienteTelefone,
    String? descricao,
    double? valor,
    String? fotoAntesPath,
    String? fotoDepoisPath,
    String? assinaturaPath,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrdemServicoModel(
      id: id ?? this.id,
      clienteNome: clienteNome ?? this.clienteNome,
      clienteTelefone: clienteTelefone ?? this.clienteTelefone,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      fotoAntesPath: fotoAntesPath ?? this.fotoAntesPath,
      fotoDepoisPath: fotoDepoisPath ?? this.fotoDepoisPath,
      assinaturaPath: assinaturaPath ?? this.assinaturaPath,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}