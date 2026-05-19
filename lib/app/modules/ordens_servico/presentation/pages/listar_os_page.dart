import 'package:flutter/material.dart';

import '../../../../../models/ordem_servico_model.dart';
import '../../../../../repositories/ordem_servico_repository.dart';
import 'finalizar_os_page.dart';

/// Tela para listar Ordens de Serviço em andamento
/// Permite ao usuário selecionar qual OS deseja finalizar
class ListarOsPage extends StatefulWidget {
  const ListarOsPage({super.key});

  @override
  State<ListarOsPage> createState() => _ListarOsPageState();
}

class _ListarOsPageState extends State<ListarOsPage> {
  final OrdemServicoRepository _osRepository = OrdemServicoRepository();
  List<OrdemServicoModel> _ordensServico = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarOrdensServico();
  }

  Future<void> _carregarOrdensServico() async {
    try {
      final ordens = await _osRepository.listarPorStatus('em_andamento');
      setState(() {
        _ordensServico = ordens;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar OS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _finalizarOS(OrdemServicoModel os) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FinalizarOsPage(ordemServicoId: os.id!),
      ),
    ).then((_) {
      // Recarregar lista após voltar da finalização
      _carregarOrdensServico();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
        backgroundColor: theme.primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ordensServico.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma OS em andamento',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cadastre uma nova OS primeiro',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarOrdensServico,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _ordensServico.length,
                    itemBuilder: (context, index) {
                      final os = _ordensServico[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => _finalizarOS(os),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'OS #${os.id}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'R\$ ${os.valor.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Cliente: ${os.clienteNome}',
                                  style: theme.textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Telefone: ${os.clienteTelefone}',
                                  
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Técnico: ${os.tecnicoNome}',
                                  style: theme.textTheme.bodyMedium,
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Serviço: ${os.servicoNome}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  os.descricao,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(os.status),
                                      size: 16,
                                      color: _getStatusColor(os.status),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatarStatus(os.status),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.orange,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _formatarData(os.createdAt),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) {
      return 'Hoje';
    } else if (diferenca.inDays == 1) {
      return 'Ontem';
    } else if (diferenca.inDays < 7) {
      return '${diferenca.inDays} dias atrás';
    } else {
      return '${data.day}/${data.month}/${data.year}';
    }
  }
  Color _getStatusColor(String status) {
  switch (status) {
    case 'finalizada':
      return Colors.green;
    case 'cancelada':
      return Colors.red;
    case 'em_andamento':
    default:
      return Colors.orange;
  }
}

IconData _getStatusIcon(String status) {
  switch (status) {
    case 'finalizada':
      return Icons.check_circle;
    case 'cancelada':
      return Icons.cancel;
    case 'em_andamento':
    default:
      return Icons.access_time;
  }
}

String _formatarStatus(String status) {
  switch (status) {
    case 'finalizada':
      return 'Finalizada';
    case 'cancelada':
      return 'Cancelada';
    case 'em_andamento':
    default:
      return 'Em andamento';
  }
}
}