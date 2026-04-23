import 'package:flutter/material.dart';

class DashboardGestaoPage extends StatelessWidget {
  const DashboardGestaoPage({super.key});

  final List<OrdemServicoMock> _ordens = const [
    OrdemServicoMock(
      numero: 'OS-001',
      cliente: 'João Silva',
      status: StatusOS.aberta,
      valor: 250.00,
    ),
    OrdemServicoMock(
      numero: 'OS-002',
      cliente: 'Maria Oliveira',
      status: StatusOS.emExecucao,
      valor: 480.00,
    ),
    OrdemServicoMock(
      numero: 'OS-003',
      cliente: 'Empresa Alfa LTDA',
      status: StatusOS.executada,
      valor: 1200.00,
    ),
    OrdemServicoMock(
      numero: 'OS-004',
      cliente: 'Carlos Souza',
      status: StatusOS.aberta,
      valor: 300.00,
    ),
  ];

  List<OrdemServicoMock> _filtrar(StatusOS? status) {
    if (status == null) return _ordens;
    return _ordens.where((os) => os.status == status).toList();
  }

  double _somarValores(List<OrdemServicoMock> lista) {
    return lista.fold(0, (total, os) => total + os.valor);
  }

  void _abrirListaOS(
    BuildContext context, {
    required String titulo,
    required List<OrdemServicoMock> lista,
  }) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: lista.isEmpty
              ? const Center(
                  child: Text('Nenhuma OS encontrada.'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        itemCount: lista.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final os = lista[index];

                          return ListTile(
                            leading: const Icon(Icons.assignment_outlined),
                            title: Text(os.numero),
                            subtitle:
                                Text('${os.cliente} • ${os.status.label}'),
                            trailing: Text(
                              'R\$ ${os.valor.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final todas = _filtrar(null);
    final abertas = _filtrar(StatusOS.aberta);
    final emExecucao = _filtrar(StatusOS.emExecucao);
    final executadas = _filtrar(StatusOS.executada);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Gestão'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _KpiCard(
                titulo: 'Total de OS',
                quantidade: todas.length,
                valor: _somarValores(todas),
                icon: Icons.receipt_long,
                color: theme.colorScheme.primary,
                onTap: () => _abrirListaOS(
                  context,
                  titulo: 'Todas as OS',
                  lista: todas,
                ),
              ),
              const SizedBox(height: 16),
              _KpiCard(
                titulo: 'OS em aberto',
                quantidade: abertas.length,
                valor: _somarValores(abertas),
                icon: Icons.pending_actions,
                color: theme.colorScheme.error,
                onTap: () => _abrirListaOS(
                  context,
                  titulo: 'OS em aberto',
                  lista: abertas,
                ),
              ),
              const SizedBox(height: 16),
              _KpiCard(
                titulo: 'OS em execução',
                quantidade: emExecucao.length,
                valor: _somarValores(emExecucao),
                icon: Icons.build_circle_outlined,
                color: Colors.amber.shade700,
                onTap: () => _abrirListaOS(
                  context,
                  titulo: 'OS em execução',
                  lista: emExecucao,
                ),
              ),
              const SizedBox(height: 16),
              _KpiCard(
                titulo: 'OS executadas',
                quantidade: executadas.length,
                valor: _somarValores(executadas),
                icon: Icons.check_circle_outline,
                color: Colors.green.shade700,
                onTap: () => _abrirListaOS(
                  context,
                  titulo: 'OS executadas',
                  lista: executadas,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String titulo;
  final int quantidade;
  final double valor;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _KpiCard({
    required this.titulo,
    required this.quantidade,
    required this.valor,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.12),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$quantidade OS',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'R\$ ${valor.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class OrdemServicoMock {
  final String numero;
  final String cliente;
  final StatusOS status;
  final double valor;

  const OrdemServicoMock({
    required this.numero,
    required this.cliente,
    required this.status,
    required this.valor,
  });
}

enum StatusOS {
  aberta,
  emExecucao,
  executada,
}

extension StatusOSExtension on StatusOS {
  String get label {
    switch (this) {
      case StatusOS.aberta:
        return 'Em aberto';
      case StatusOS.emExecucao:
        return 'Em execução';
      case StatusOS.executada:
        return 'Executada';
    }
  }
}
