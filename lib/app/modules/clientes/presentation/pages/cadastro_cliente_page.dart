import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:serviceflow/app/core/helpers/loader_mixin.dart';
import 'package:serviceflow/app/core/helpers/messages_mixin.dart';
import 'package:serviceflow/app/shared/widgets/app_logo.dart';
import 'package:serviceflow/app/shared/widgets/custom_button.dart';
import 'package:serviceflow/app/shared/widgets/custom_text_field.dart';
import '../../../../../models/cliente_model.dart';
import '../../../../../repositories/cliente_repository.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage>
    with MessagesMixin, LoaderMixin {
  final _formKey = GlobalKey<FormState>();

  final _clienteRepository = ClienteRepository();
  final _nomeController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $fieldName';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o e-mail';
    }

    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (!regex.hasMatch(value.trim())) {
      return 'Informe um e-mail válido';
    }

    return null;
  }

  Future<void> _salvar() async {
  if (!(_formKey.currentState?.validate() ?? false)) {
    return;
  }

  try {
    showLoader();

    final cliente = ClienteModel(
      nome: _nomeController.text.trim(),
      documento: _cpfCnpjController.text.trim(),
      email: _emailController.text.trim(),
      telefone: _telefoneController.text.trim(),
      dataCriacao: DateTime.now().toIso8601String(),
    );

    await _clienteRepository.salvar(cliente);

    if (!mounted) return;

    hideLoader();
    showSuccess('Cliente cadastrado com sucesso!');
    Navigator.of(context).pop();
  } catch (e) {
    hideLoader();

    if (!mounted) return;

    showError('Erro ao cadastrar cliente: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cliente'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const AppLogo(width: double.infinity, height: 140),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _nomeController,
                  label: 'Nome/Razão Social',
                  hint: 'Digite o nome do cliente',
                  prefixIcon: Icons.person_outline,
                  validator: (value) =>
                      _requiredValidator(value, 'o nome/razão social'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _cpfCnpjController,
                  label: 'CPF/CNPJ',
                  hint: 'Digite o CPF',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfMask],
                  validator: (value) => _requiredValidator(value, 'o CPF/CNPJ'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  hint: 'Digite o e-mail',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _telefoneController,
                  label: 'Telefone',
                  hint: 'Digite o telefone',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_telefoneMask],
                  textInputAction: TextInputAction.done,
                  validator: (value) => _requiredValidator(value, 'o telefone'),
                  onFieldSubmitted: _salvar,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: 'Salvar Cliente',
                  onPressed: _salvar,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
