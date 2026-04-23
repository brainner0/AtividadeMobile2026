import 'package:flutter/material.dart';

import '../../../clientes/presentation/pages/cadastro_cliente_page.dart';
import '../../../ordens_servico/presentation/pages/cadastro_os_page.dart';
import '../../../dashboard/presentation/pages/dashboard_gestao_page.dart';

class MenuServicosPage extends StatelessWidget {
  const MenuServicosPage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => page,
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final menuItems = [
      _MenuItem(
        icon: Icons.dashboard_outlined,
        title: 'Dashboard de Gestão',
        subtitle: 'Resumo de OS, faturamento e produtividade',
        page: const DashboardGestaoPage(),
      ),
      _MenuItem(
        icon: Icons.person_add_alt_1,
        title: 'Cadastrar Cliente',
        subtitle: 'Cadastrar dados do cliente',
        page: const CadastroClientePage(),
      ),
      _MenuItem(
        icon: Icons.assignment_add,
        title: 'Cadastrar OS',
        subtitle: 'Criar uma ordem de serviço',
        page: const CadastroOsPage(),
      ),
    ];

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
              const SizedBox(height: 8),
              Text(
                'Acesse as principais funcionalidades do sistema.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];

                    return _MenuButton(
                      icon: item.icon,
                      title: item.title,
                      subtitle: item.subtitle,
                      onTap: () => _navigateTo(context, item.page),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _logout(context),
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

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
  });
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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
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
