class OrdemServicoModel {
  final int? id;

  final String clienteNome;
  final String clienteTelefone;

  final String tecnicoNome;
  final String servicoNome;

  final String descricao;

  final double valor;

  final String fotoAntesPath;

  final String? fotoDepoisPath;

  final String? assinaturaPath;

  final String status;

  final DateTime createdAt;

  final DateTime? updatedAt;

  OrdemServicoModel({
    this.id,

    required this.clienteNome,
    required this.clienteTelefone,

    required this.tecnicoNome,
    required this.servicoNome,

    required this.descricao,

    required this.valor,

    required this.fotoAntesPath,

    this.fotoDepoisPath,

    this.assinaturaPath,

    this.status = 'em_andamento',

    DateTime? createdAt,

    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'clienteNome': clienteNome,
      'clienteTelefone': clienteTelefone,

      'tecnicoNome': tecnicoNome,
      'servicoNome': servicoNome,

      'descricao': descricao,

      'valor': valor,

      'fotoAntesPath': fotoAntesPath,

      'fotoDepoisPath': fotoDepoisPath,

      'assinaturaPath': assinaturaPath,

      'status': status,

      'createdAt':
          createdAt.toIso8601String(),

      'updatedAt':
          updatedAt?.toIso8601String(),
    };
  }

  factory OrdemServicoModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return OrdemServicoModel(
      id: map['id'],

      clienteNome:
          map['clienteNome'],

      clienteTelefone:
          map['clienteTelefone'],

      tecnicoNome:
          map['tecnicoNome'] ?? '',

      servicoNome:
          map['servicoNome'] ?? '',

      descricao:
          map['descricao'],

      valor:
          (map['valor'] as num)
              .toDouble(),

      fotoAntesPath:
          map['fotoAntesPath'],

      fotoDepoisPath:
          map['fotoDepoisPath'],

      assinaturaPath:
          map['assinaturaPath'],

      status:
          map['status'],

      createdAt:
          DateTime.parse(
        map['createdAt'],
      ),

      updatedAt:
          map['updatedAt'] != null
              ? DateTime.parse(
                  map['updatedAt'],
                )
              : null,
    );
  }

  OrdemServicoModel copyWith({
    int? id,

    String? clienteNome,
    String? clienteTelefone,

    String? tecnicoNome,
    String? servicoNome,

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

      clienteNome:
          clienteNome ??
              this.clienteNome,

      clienteTelefone:
          clienteTelefone ??
              this.clienteTelefone,

      tecnicoNome:
          tecnicoNome ??
              this.tecnicoNome,

      servicoNome:
          servicoNome ??
              this.servicoNome,

      descricao:
          descricao ??
              this.descricao,

      valor:
          valor ?? this.valor,

      fotoAntesPath:
          fotoAntesPath ??
              this.fotoAntesPath,

      fotoDepoisPath:
          fotoDepoisPath ??
              this.fotoDepoisPath,

      assinaturaPath:
          assinaturaPath ??
              this.assinaturaPath,

      status:
          status ?? this.status,

      createdAt:
          createdAt ??
              this.createdAt,

      updatedAt:
          updatedAt ??
              this.updatedAt,
    );
  }
}