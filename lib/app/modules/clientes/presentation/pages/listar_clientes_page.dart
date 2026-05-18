import 'package:flutter/material.dart';

import '../../../../../models/cliente_model.dart';
import '../../../../../repositories/cliente_repository.dart';

class ListarClientesPage extends StatefulWidget {
  const ListarClientesPage({super.key});

  @override
  State<ListarClientesPage> createState() => _ListarClientesPageState();
}

class _ListarClientesPageState extends State<ListarClientesPage> {
  final ClienteRepository _clienteRepository = ClienteRepository();

  late Future<List<ClienteModel>> _clientesFuture;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  void _carregarClientes() {
    _clientesFuture = _clienteRepository.listar();
  }

  Future<void> _deletarCliente(int id) async {
    await _clienteRepository.deletar(id);

    setState(() {
      _carregarClientes();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cliente deletado com sucesso'),
      ),
    );
  }

  Future<void> _confirmarDelete(ClienteModel cliente) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir cliente'),
          content: Text('Deseja excluir ${cliente.nome}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && cliente.id != null) {
      await _deletarCliente(cliente.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes cadastrados'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<ClienteModel>>(
        future: _clientesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar clientes: ${snapshot.error}'),
            );
          }

          final clientes = snapshot.data ?? [];

          if (clientes.isEmpty) {
            return const Center(
              child: Text('Nenhum cliente cadastrado'),
            );
          }

          return ListView.separated(
            itemCount: clientes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final cliente = clientes[index];

              return ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(cliente.nome),
                subtitle: Text(
                  '${cliente.email}\n${cliente.telefone}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmarDelete(cliente),
                ),
              );
            },
          );
        },
      ),
    );
  }
}