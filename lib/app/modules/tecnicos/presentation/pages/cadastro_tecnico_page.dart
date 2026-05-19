import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../models/tecnico_model.dart';
import '../../../../../repositories/tecnico_repository.dart';
import '../../../../shared/mixins/loader_mixin.dart';
import '../../../../shared/mixins/messages_mixin.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class CadastroTecnicoPage extends StatefulWidget {
  const CadastroTecnicoPage({super.key});

  @override
  State<CadastroTecnicoPage> createState() =>
      _CadastroTecnicoPageState();
}

class _CadastroTecnicoPageState
    extends State<CadastroTecnicoPage>
    with MessagesMixin, LoaderMixin {

  final _formKey = GlobalKey<FormState>();

  final _tecnicoRepository = TecnicoRepository();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _especialidadeController = TextEditingController();

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _especialidadeController.dispose();
    super.dispose();
  }

  String? _requiredValidator(
    String? value,
    String fieldName,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $fieldName';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o e-mail';
    }

    final regex = RegExp(
      r'^[\w\.-]+@[\w\.-]+\.\w+$',
    );

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

      final tecnico = TecnicoModel(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        telefone: _telefoneController.text.trim(),
        especialidade:
            _especialidadeController.text.trim(),
        dataCriacao:
            DateTime.now().toIso8601String(),
      );

      await _tecnicoRepository.salvar(tecnico);

      if (!mounted) return;

      hideLoader();

      showSuccess(
        'Técnico cadastrado com sucesso!',
      );

      Navigator.of(context).pop();

    } catch (e) {
      hideLoader();

      if (!mounted) return;

      showError(
        'Erro ao cadastrar técnico: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Técnico'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                CustomTextField(
                  controller: _nomeController,
                  label: 'Nome',
                  hint: 'Digite o nome',
                  prefixIcon: Icons.person_outline,
                  validator: (value) =>
                      _requiredValidator(
                    value,
                    'o nome',
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _emailController,
                  label: 'E-mail',
                  hint: 'Digite o e-mail',
                  prefixIcon: Icons.email_outlined,
                  keyboardType:
                      TextInputType.emailAddress,
                  validator: _emailValidator,
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller: _telefoneController,
                  label: 'Telefone',
                  hint: 'Digite o telefone',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType:
                      TextInputType.phone,
                  inputFormatters: [
                    _telefoneMask,
                  ],
                  validator: (value) =>
                      _requiredValidator(
                    value,
                    'o telefone',
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller:
                      _especialidadeController,
                  label: 'Especialidade',
                  hint:
                      'Ex: Elétrica, Hidráulica...',
                  prefixIcon: Icons.build_outlined,
                  validator: (value) =>
                      _requiredValidator(
                    value,
                    'a especialidade',
                  ),
                ),

                const SizedBox(height: 32),

                CustomButton(
                  label: 'Salvar Técnico',
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