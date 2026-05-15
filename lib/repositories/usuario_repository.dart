import '../database/db_helper.dart';
import '../models/usuario_model.dart';

class UsuarioRepository {
  final DbHelper _dbHelper = DbHelper.instance;

  Future<int> salvar(UsuarioModel usuario) async {
    final db = await _dbHelper.database;

    return db.insert(
      'usuarios',
      usuario.toMap(),
    );
  }

  Future<UsuarioModel?> buscarPorEmail(String email) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UsuarioModel.fromMap(result.first);
  }

  Future<UsuarioModel?> autenticar({
    required String email,
    required String senha,
  }) async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return UsuarioModel.fromMap(result.first);
  }

  Future<List<UsuarioModel>> listar() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'usuarios',
      orderBy: 'nome ASC',
    );

    return result.map((map) => UsuarioModel.fromMap(map)).toList();
  }

  Future<int> atualizar(UsuarioModel usuario) async {
    final db = await _dbHelper.database;

    return db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await _dbHelper.database;

    return db.delete(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}