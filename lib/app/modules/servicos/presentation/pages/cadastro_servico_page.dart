import 'package:flutter/material.dart';

import '../../../../../models/servico_model.dart';
import '../../../../../repositories/servico_repository.dart';
import '../../../../shared/mixins/loader_mixin.dart';
import '../../../../shared/mixins/messages_mixin.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class CadastroServicoPage extends StatefulWidget {
  const CadastroServicoPage({super.key});

  @override
  State<CadastroServicoPage> createState() =>
      _CadastroServicoPageState();
}

class _CadastroServicoPageState
    extends State<CadastroServicoPage>
    with MessagesMixin, LoaderMixin {

  final _formKey = GlobalKey<FormState>();

  final _servicoRepository =
      ServicoRepository();

  final _nomeController =
      TextEditingController();

  final _descricaoController =
      TextEditingController();

  final _valorController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
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

  Future<void> _salvar() async {

    if (!(_formKey.currentState
            ?.validate() ??
        false)) {
      return;
    }

    try {

      showLoader();

      final servico = ServicoModel(
        nome:
            _nomeController.text.trim(),

        descricao:
            _descricaoController.text.trim(),

        valor: double.parse(
          _valorController.text
              .replaceAll(',', '.'),
        ),

        dataCriacao:
            DateTime.now()
                .toIso8601String(),
      );

      await _servicoRepository
          .salvar(servico);

      if (!mounted) return;

      hideLoader();

      showSuccess(
        'Serviço cadastrado com sucesso!',
      );

      Navigator.of(context).pop();

    } catch (e) {

      hideLoader();

      if (!mounted) return;

      showError(
        'Erro ao cadastrar serviço: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Cadastro de Serviço'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(24),

          child: Form(
            key: _formKey,

            child: Column(
              children: [

                CustomTextField(
                  controller:
                      _nomeController,

                  label: 'Nome do Serviço',

                  hint:
                      'Digite o nome do serviço',

                  prefixIcon:
                      Icons.build_outlined,

                  validator: (value) =>
                      _requiredValidator(
                    value,
                    'o nome do serviço',
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller:
                      _descricaoController,

                  label: 'Descrição',

                  hint:
                      'Descreva o serviço',

                  maxLines: 4,

                  prefixIcon:
                      Icons.description_outlined,

                  validator: (value) =>
                      _requiredValidator(
                    value,
                    'a descrição',
                  ),
                ),

                const SizedBox(height: 16),

                CustomTextField(
                  controller:
                      _valorController,

                  label: 'Valor',

                  hint: '0,00',

                  prefixIcon:
                      Icons.attach_money,

                  keyboardType:
                      const TextInputType
                          .numberWithOptions(
                    decimal: true,
                  ),

                  validator: (value) {

                    if (value == null ||
                        value.trim().isEmpty) {

                      return 'Informe o valor';
                    }

                    final valor =
                        double.tryParse(
                      value.replaceAll(
                        ',',
                        '.',
                      ),
                    );

                    if (valor == null ||
                        valor <= 0) {

                      return 'Informe um valor válido';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 32),

                CustomButton(
                  label:
                      'Salvar Serviço',

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