import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  static final DbHelper instance = DbHelper._init();

  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {

    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('app.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
      onOpen: (db) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Tabela de clientes
    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        telefone TEXT
      )
    ''');

    // Tabela de ordens de serviço
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ordens_servico (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clienteNome TEXT NOT NULL,
        clienteTelefone TEXT NOT NULL,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL,
        fotoAntesPath TEXT NOT NULL,
        fotoDepoisPath TEXT,
        assinaturaPath TEXT,
        status TEXT NOT NULL DEFAULT 'em_andamento',
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');
  }
}