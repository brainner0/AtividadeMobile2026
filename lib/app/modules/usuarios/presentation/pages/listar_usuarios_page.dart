import 'package:flutter/material.dart';

import '../../../../../models/usuario_model.dart';
import '../../../../../repositories/usuario_repository.dart';

class ListarUsuariosPage extends StatefulWidget {
  const ListarUsuariosPage({super.key});

  @override
  State<ListarUsuariosPage> createState() => _ListarUsuariosPageState();
}

class _ListarUsuariosPageState extends State<ListarUsuariosPage> {
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  late Future<List<UsuarioModel>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  void _carregarUsuarios() {
    _usuariosFuture = _usuarioRepository.listar();
  }

  Future<void> _deletarUsuario(int id) async {
    await _usuarioRepository.deletar(id);

    setState(() {
      _carregarUsuarios();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Usuário deletado com sucesso'),
      ),
    );
  }

  Future<void> _confirmarDelete(UsuarioModel usuario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir usuário'),
          content: Text('Deseja excluir ${usuario.nome}?'),
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

    if (confirmar == true && usuario.id != null) {
      await _deletarUsuario(usuario.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários cadastrados'),
      ),
      body: FutureBuilder<List<UsuarioModel>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar usuários: ${snapshot.error}'),
            );
          }

          final usuarios = snapshot.data ?? [];

          if (usuarios.isEmpty) {
            return const Center(
              child: Text('Nenhum usuário cadastrado'),
            );
          }

          return ListView.separated(
            itemCount: usuarios.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final usuario = usuarios[index];

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(usuario.nome),
                subtitle: Text(usuario.email),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _confirmarDelete(usuario),
                ),
              );
            },
          );
        },
      ),
    );
  }
}