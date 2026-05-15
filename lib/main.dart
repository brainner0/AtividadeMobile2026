import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'database/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeDatabase();

  runApp(const AppWidget());
}

Future<void> _initializeDatabase() async {
  try {
    await DbHelper.instance.database;
    debugPrint('✅ SQLite inicializado com sucesso!');
  } catch (e) {
    debugPrint('❌ Erro ao inicializar SQLite: $e');
  }
}