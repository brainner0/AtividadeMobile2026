import '../database/db_helper.dart';
import '../models/tecnico_model.dart';

class TecnicoRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> salvar(TecnicoModel tecnico) async {
    final db = await _dbHelper.database;

    return db.insert(
      'tecnicos',
      tecnico.toMap(),
    );
  }

  Future<List<TecnicoModel>> listar() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'tecnicos',
      orderBy: 'nome ASC',
    );

    return result.map((map) => TecnicoModel.fromMap(map)).toList();
  }

  Future<TecnicoModel?> buscarPorId(int id) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'tecnicos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TecnicoModel.fromMap(result.first);
  }

  Future<int> atualizar(TecnicoModel tecnico) async {
    final db = await _dbHelper.database;

    return db.update(
      'tecnicos',
      tecnico.toMap(),
      where: 'id = ?',
      whereArgs: [tecnico.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;

    return db.delete(
      'tecnicos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}