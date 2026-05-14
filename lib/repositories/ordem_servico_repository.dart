import 'package:sqflite/sqflite.dart';
import '../../database/db_helper.dart';
import '../models/ordem_servico_model.dart';

/// Repositório para operações CRUD de Ordem de Serviço
class OrdemServicoRepository {
  final Future<Database> _db = DbHelper.instance.database;

  /// Salva uma nova OS no banco
  Future<int> salvar(OrdemServicoModel os) async {
    final db = await _db;
    return await db.insert('ordens_servico', os.toMap());
  }

  /// Lista todas as OS
  Future<List<OrdemServicoModel>> listar() async {
    final db = await _db;
    final result = await db.query('ordens_servico', orderBy: 'createdAt DESC');
    return result.map((map) => OrdemServicoModel.fromMap(map)).toList();
  }

  /// Lista OS por status
  Future<List<OrdemServicoModel>> listarPorStatus(String status) async {
    final db = await _db;
    final result = await db.query(
      'ordens_servico',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'createdAt DESC',
    );
    return result.map((map) => OrdemServicoModel.fromMap(map)).toList();
  }

  /// Busca OS por ID
  Future<OrdemServicoModel?> buscarPorId(int id) async {
    final db = await _db;
    final result = await db.query(
      'ordens_servico',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return OrdemServicoModel.fromMap(result.first);
    }
    return null;
  }

  /// Atualiza uma OS existente
  Future<int> atualizar(OrdemServicoModel os) async {
    final db = await _db;
    return await db.update(
      'ordens_servico',
      os.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [os.id],
    );
  }

  /// Deleta uma OS
  Future<int> deletar(int id) async {
    final db = await _db;
    return await db.delete(
      'ordens_servico',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Finaliza uma OS (atualiza status e campos de finalização)
  Future<int> finalizar(int id, String fotoDepoisPath, String assinaturaPath) async {
    final db = await _db;
    return await db.update(
      'ordens_servico',
      {
        'fotoDepoisPath': fotoDepoisPath,
        'assinaturaPath': assinaturaPath,
        'status': 'finalizada',
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}