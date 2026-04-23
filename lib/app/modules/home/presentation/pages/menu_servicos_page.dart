import 'package:flutter/material.dart';

import '../../../clientes/presentation/pages/cadastro_cliente_page.dart';
// ajuste este import para o nome real da sua tela de OS
//import '../../../ordens_servico/presentation/pages/cadastro_os_page.dart';

class MenuServicosPage extends StatelessWidget {
  const MenuServicosPage({super.key});

  void _abrirCadastroCliente(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CadastroClientePage(),
      ),
    );
  }
/*
  void _abrirCadastroOS(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CadastroOsPage(),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu de Serviços'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Selecione uma opção',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _MenuButton(
                icon: Icons.person_add_alt_1,
                title: 'Cadastrar Cliente',
                subtitle: 'Cadastrar dados do cliente',
                onTap: () => _abrirCadastroCliente(context),
              ),
              /* const SizedBox(height: 16),
              _MenuButton(
                icon: Icons.assignment_add,
                title: 'Cadastrar OS',
                subtitle: 'Criar uma ordem de serviço',
                onTap: () => _abrirCadastroOS(context),
              ),
              */
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sair'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withOpacity(0.12),
          child: Icon(
            icon,
            color: theme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}
