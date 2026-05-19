import '../database/db_helper.dart';
import '../models/servico_model.dart';

class ServicoRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> salvar(ServicoModel servico) async {
    final db = await _dbHelper.database;

    return db.insert(
      'servicos',
      servico.toMap(),
    );
  }

  Future<List<ServicoModel>> listar() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'servicos',
      orderBy: 'nome ASC',
    );

    return result.map((map) => ServicoModel.fromMap(map)).toList();
  }

  Future<ServicoModel?> buscarPorId(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'servicos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ServicoModel.fromMap(result.first);
  }

  Future<int> atualizar(ServicoModel servico) async {
    final db = await _dbHelper.database;

    return db.update(
      'servicos',
      servico.toMap(),
      where: 'id = ?',
      whereArgs: [servico.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;

    return db.delete(
      'servicos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}