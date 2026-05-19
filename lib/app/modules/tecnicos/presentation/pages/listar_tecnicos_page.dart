import 'package:flutter/material.dart';

import '../../../../../models/tecnico_model.dart';
import '../../../../../repositories/tecnico_repository.dart';

class ListarTecnicosPage extends StatefulWidget {
  const ListarTecnicosPage({super.key});

  @override
  State<ListarTecnicosPage> createState() =>
      _ListarTecnicosPageState();
}

class _ListarTecnicosPageState
    extends State<ListarTecnicosPage> {

  final TecnicoRepository _tecnicoRepository =
      TecnicoRepository();

  late Future<List<TecnicoModel>>
      _tecnicosFuture;

  @override
  void initState() {
    super.initState();
    _carregarTecnicos();
  }

  void _carregarTecnicos() {
    _tecnicosFuture =
        _tecnicoRepository.listar();
  }

  Future<void> _deletarTecnico(int id) async {
    await _tecnicoRepository.deletar(id);

    setState(() {
      _carregarTecnicos();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Técnico deletado com sucesso'),
      ),
    );
  }

  Future<void> _confirmarDelete(
    TecnicoModel tecnico,
  ) async {

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Excluir técnico'),
          content: Text(
            'Deseja excluir ${tecnico.nome}?',
          ),
          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pop(false),
              child: const Text('Cancelar'),
            ),

            TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true &&
        tecnico.id != null) {

      await _deletarTecnico(
        tecnico.id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Técnicos cadastrados'),
        centerTitle: true,
      ),

      body: FutureBuilder<List<TecnicoModel>>(
        future: _tecnicosFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                'Erro ao carregar técnicos: ${snapshot.error}',
              ),
            );
          }

          final tecnicos =
              snapshot.data ?? [];

          if (tecnicos.isEmpty) {

            return const Center(
              child: Text(
                'Nenhum técnico cadastrado',
              ),
            );
          }

          return ListView.separated(
            itemCount: tecnicos.length,

            separatorBuilder: (_, __) =>
                const Divider(height: 1),

            itemBuilder: (context, index) {

              final tecnico =
                  tecnicos[index];

              return ListTile(
                leading:
                    const Icon(Icons.engineering),

                title:
                    Text(tecnico.nome),

                subtitle: Text(
                  '${tecnico.email}\n${tecnico.especialidade}',
                ),

                isThreeLine: true,

                trailing: IconButton(
                  icon:
                      const Icon(Icons.delete),

                  onPressed: () =>
                      _confirmarDelete(
                    tecnico,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}