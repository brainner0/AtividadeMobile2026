import 'package:serviceflow/app/modules/clientes/cliente.model.dart';

enum OrdemServicoStatus { aberto, execucao, executada }

class OrdemServico {
  final String id;
  final Cliente cliente;
  final String descricao;
  final double valor;
  final OrdemServicoStatus status;
  final DateTime data;
  final String? fotoAntesPath;
  final String? fotoDepoisPath;

  OrdemServico({
    required this.id,
    required this.cliente,
    required this.descricao,
    required this.valor,
    required this.status,
    required this.data,
    this.fotoAntesPath,
    this.fotoDepoisPath,
  });

  String get statusLabel {
    switch (status) {
      case OrdemServicoStatus.aberto:
        return 'Em aberto';
      case OrdemServicoStatus.execucao:
        return 'Em execução';
      case OrdemServicoStatus.executada:
        return 'Executada';
    }
  }
}
