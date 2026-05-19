import 'package:flutter/material.dart';

import '../../../../../models/servico_model.dart';
import '../../../../../repositories/servico_repository.dart';

class ListarServicosPage extends StatefulWidget {
  const ListarServicosPage({super.key});

  @override
  State<ListarServicosPage> createState() =>
      _ListarServicosPageState();
}

class _ListarServicosPageState
    extends State<ListarServicosPage> {

  final ServicoRepository _servicoRepository =
      ServicoRepository();

  late Future<List<ServicoModel>>
      _servicosFuture;

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  void _carregarServicos() {
    _servicosFuture =
        _servicoRepository.listar();
  }

  Future<void> _deletarServico(
    int id,
  ) async {

    await _servicoRepository
        .deletar(id);

    setState(() {
      _carregarServicos();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content:
            Text('Serviço deletado com sucesso'),
      ),
    );
  }

  Future<void> _confirmarDelete(
    ServicoModel servico,
  ) async {

    final confirmar =
        await showDialog<bool>(
      context: context,

      builder: (context) {

        return AlertDialog(
          title:
              const Text('Excluir serviço'),

          content: Text(
            'Deseja excluir ${servico.nome}?',
          ),

          actions: [

            TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pop(false),

              child:
                  const Text('Cancelar'),
            ),

            TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pop(true),

              child:
                  const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmar == true &&
        servico.id != null) {

      await _deletarServico(
        servico.id!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Serviços cadastrados'),

        centerTitle: true,
      ),

      body:
          FutureBuilder<List<ServicoModel>>(
        future: _servicosFuture,

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
                'Erro ao carregar serviços: ${snapshot.error}',
              ),
            );
          }

          final servicos =
              snapshot.data ?? [];

          if (servicos.isEmpty) {

            return const Center(
              child: Text(
                'Nenhum serviço cadastrado',
              ),
            );
          }

          return ListView.separated(
            itemCount: servicos.length,

            separatorBuilder: (_, __) =>
                const Divider(height: 1),

            itemBuilder: (context, index) {

              final servico =
                  servicos[index];

              return ListTile(
                leading:
                    const Icon(Icons.build),

                title:
                    Text(servico.nome),

                subtitle: Text(
                  '${servico.descricao}\nR\$ ${servico.valor.toStringAsFixed(2)}',
                ),

                isThreeLine: true,

                trailing: IconButton(
                  icon:
                      const Icon(Icons.delete),

                  onPressed: () =>
                      _confirmarDelete(
                    servico,
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