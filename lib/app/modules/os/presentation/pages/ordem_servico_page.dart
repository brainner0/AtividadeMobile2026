import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:serviceflow/app/modules/clientes/cliente.model.dart';
import 'package:serviceflow/app/modules/os/ordem_servico.model.dart';
import 'package:serviceflow/app/shared/mixins/loader_mixin.dart';
import 'package:serviceflow/app/shared/mixins/messages_mixin.dart';
import 'package:serviceflow/app/shared/widgets/custom_button.dart';
import 'package:serviceflow/app/shared/widgets/custom_text_field.dart';

class OrdemServicoPage extends StatefulWidget {
  const OrdemServicoPage({super.key});

  @override
  State<OrdemServicoPage> createState() => _OrdemServicoPageState();
}

class _OrdemServicoPageState extends State<OrdemServicoPage> with LoaderMixin, MessagesMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _signatureController = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final List<Cliente> _clientes = [
    Cliente(nome: 'Alpha Serviços', email: 'alpha@serviceflow.com', telefone: '(11) 98765-4321'),
    Cliente(nome: 'Beta Soluções', email: 'beta@serviceflow.com', telefone: '(21) 99876-5432'),
    Cliente(nome: 'Gamma Engenharia', email: 'gamma@serviceflow.com', telefone: '(31) 99654-3210'),
  ];

  Cliente? _selectedCliente;
  Uint8List? _fotoAntes;
  Uint8List? _fotoDepois;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isAntes) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    setState(() {
      if (isAntes) {
        _fotoAntes = bytes;
      } else {
        _fotoDepois = bytes;
      }
    });
  }

  Future<void> _salvarOrdem() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCliente == null) {
      showError('Selecione um cliente');
      return;
    }
    if (_signatureController.isEmpty) {
      showError('Assinatura obrigatória');
      return;
    }

    showLoader();
    await Future.delayed(const Duration(seconds: 2));
    hideLoader();

    final novaOrdem = OrdemServico(
      id: 'OS-${DateTime.now().millisecondsSinceEpoch}',
      cliente: _selectedCliente!,
      descricao: _descricaoController.text.trim(),
      valor: double.parse(_valorController.text.replaceAll(',', '.')),
      status: OrdemServicoStatus.aberto,
      data: DateTime.now(),
      fotoAntesPath: _fotoAntes != null ? 'Antes' : null,
      fotoDepoisPath: _fotoDepois != null ? 'Depois' : null,
    );

    showSuccess('Ordem de serviço salva com sucesso');
    Navigator.of(context).pop(novaOrdem);
  }

  Widget _buildPhotoCard({
    required String label,
    required Uint8List? photo,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: photo != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.memory(photo, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 32, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 8),
                  Text(label, textAlign: TextAlign.center),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Ordem de Serviço')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<Cliente>(
                  value: _selectedCliente,
                  decoration: InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                  ),
                  items: _clientes
                      .map(
                        (cliente) => DropdownMenuItem(
                          value: cliente,
                          child: Text(cliente.nome),
                        ),
                      )
                      .toList(),
                  onChanged: (cliente) => setState(() => _selectedCliente = cliente),
                  validator: (value) => value == null ? 'Selecione um cliente' : null,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Descrição',
                  controller: _descricaoController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe a descrição da OS';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Valor estimado',
                  controller: _valorController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe o valor estimado';
                    }
                    if (double.tryParse(value.replaceAll(',', '.')) == null) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text('Fotos', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPhotoCard(label: 'Foto Antes', photo: _fotoAntes, onTap: () => _pickImage(true)),
                    _buildPhotoCard(label: 'Foto Depois', photo: _fotoDepois, onTap: () => _pickImage(false)),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Assinatura', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: theme.canvasColor,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => setState(() => _signatureController.clear()),
                  child: const Text('Limpar assinatura'),
                ),
                const SizedBox(height: 24),
                CustomButton(label: 'Salvar OS', onPressed: _salvarOrdem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
