import '../database/db_helper.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> salvar(ClienteModel cliente) async {
    final db = await _dbHelper.database;

    return db.insert(
      'clientes',
      cliente.toMap(),
    );
  }

  Future<List<ClienteModel>> listar() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'clientes',
      orderBy: 'nome ASC',
    );

    return result
        .map((map) => ClienteModel.fromMap(map))
        .toList();
  }

  Future<ClienteModel?> buscarPorId(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return ClienteModel.fromMap(result.first);
  }

  Future<int> atualizar(ClienteModel cliente) async {
    final db = await _dbHelper.database;

    return db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;

    return db.delete(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}