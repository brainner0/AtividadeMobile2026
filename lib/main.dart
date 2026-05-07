import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'database/db_helper.dart';

void main() async {
  // 1. Garante a inicialização da comunicação com o sistema nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o banco de dados
  try {
    final db = await DbHelper.instance.database;
    debugPrint('✅ SQLite inicializado com sucesso!');
  } catch (e) {
    debugPrint('❌ Erro ao inicializar SQLite: $e');
  }

  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWidget();
  }
}
