import '../database/db_helper.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  Future<void> salvar(ClienteModel cliente) async {
    final db = await DbHelper.instance.database;

    await db.insert(
      'clientes',
      cliente.toMap(),
    );
  }

  Future<List<ClienteModel>> listar() async {
    final db = await DbHelper.instance.database;

    final result = await db.query('clientes');

    return result.map((e) {
      return ClienteModel.fromMap(e);
    }).toList();
  }

  Future<void> atualizar(ClienteModel cliente) async {
    final db = await DbHelper.instance.database;

    await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<void> deletar(int id) async {
    final db = await DbHelper.instance.database;

    await db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
