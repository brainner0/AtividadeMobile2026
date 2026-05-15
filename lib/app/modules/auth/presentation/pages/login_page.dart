import 'package:flutter/material.dart';

import '../../../../app_routes.dart';
import '../../../../shared/mixins/messages_mixin.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../../repositories/usuario_repository.dart';
import '../../../home/presentation/pages/menu_servicos_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  final _usuarioRepository = UsuarioRepository();
  late TextEditingController emailController;
  late TextEditingController senhaController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    senhaController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> _executarLogin() async {
  if (!_formKey.currentState!.validate()) return;

  final usuario = await _usuarioRepository.autenticar(
    email: emailController.text.trim(),
    senha: senhaController.text.trim(),
  );

  if (usuario == null) {
    showError('E-mail ou senha inválidos');
    return;
  }

  showSuccess('Login realizado com sucesso');

  if (!mounted) return;

  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (_) => const MenuServicosPage(),
    ),
  );
}

  void _irParaRegistro() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppLogo(width: double.infinity, height: 180),
                const SizedBox(height: 24),
                Text(
                  'Bem-vindo de volta',
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  label: 'E-mail',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Senha',
                  controller: senhaController,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe sua senha';
                    }
                    if (value.length < 7) {
                      return 'A senha deve ter mais de 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Entrar',
                  onPressed: _executarLogin,
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _irParaRegistro,
                  child: Text(
                    'Criar conta',
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
