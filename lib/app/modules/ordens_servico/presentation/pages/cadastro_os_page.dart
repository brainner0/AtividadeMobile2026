import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../clientes/cliente.model.dart';
import '../../../../shared/mixins/loader_mixin.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';

class CadastroOsPage extends StatefulWidget {
  const CadastroOsPage({super.key});

  @override
  State<CadastroOsPage> createState() => _CadastroOsPageState();
}

class _CadastroOsPageState extends State<CadastroOsPage> with LoaderMixin {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _clienteDropdown = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Dados em memória para clientes (simulando banco de dados)
  final List<Cliente> _clientes = [
    Cliente(nome: 'João Silva', email: 'joao@email.com', telefone: '(11) 99999-0001'),
    Cliente(nome: 'Maria Santos', email: 'maria@email.com', telefone: '(11) 99999-0002'),
    Cliente(nome: 'Pedro Oliveira', email: 'pedro@email.com', telefone: '(11) 99999-0003'),
    Cliente(nome: 'Ana Costa', email: 'ana@email.com', telefone: '(11) 99999-0004'),
    Cliente(nome: 'Carlos Ferreira', email: 'carlos@email.com', telefone: '(11) 99999-0005'),
  ];

  Cliente? _clienteSelecionado;
  XFile? _fotoAntes;
  XFile? _fotoDepois;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _clienteDropdown.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _tirarFoto(bool isFotoAntes) async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (foto != null) {
        setState(() {
          if (isFotoAntes) {
            _fotoAntes = foto;
          } else {
            _fotoDepois = foto;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao capturar foto: $e')),
        );
      }
    }
  }

  Future<void> _salvarOS() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente')),
      );
      return;
    }

    if (_signatureController.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, assine no canvas abaixo')),
      );
      return;
    }

    // Exibir LoaderMixin por 2 segundos
    showLoader();
    await Future.delayed(const Duration(seconds: 2));
    hideLoader();

    // Simular salvamento (aqui você faria a chamada API)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ordem de Serviço salva com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpar formulário
      _formKey.currentState!.reset();
      _descricaoController.clear();
      _valorController.clear();
      _clienteDropdown.clear();
      setState(() {
        _clienteSelecionado = null;
        _fotoAntes = null;
        _fotoDepois = null;
      });
      _signatureController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de OS'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Seleção de Cliente
              Text(
                'Cliente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Cliente>(
                value: _clienteSelecionado,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selecione um cliente',
                ),
                items: _clientes.map((cliente) {
                  return DropdownMenuItem<Cliente>(
                    value: cliente,
                    child: Text(cliente.nome),
                  );
                }).toList(),
                onChanged: (Cliente? value) {
                  setState(() {
                    _clienteSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Descrição
              CustomTextField(
                controller: _descricaoController,
                label: 'Descrição do Serviço',
                hint: 'Descreva os serviços a serem realizados',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Valor
              CustomTextField(
                controller: _valorController,
                label: 'Valor Estimado (R\$)',
                hint: '0,00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  final valor = double.tryParse(value.replaceAll(',', '.'));
                  if (valor == null || valor <= 0) {
                    return 'Por favor, insira um valor válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Fotos - Antes
              Text(
                'Foto Antes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildFotoContainer(
                foto: _fotoAntes,
                onTap: () => _tirarFoto(true),
                label: 'Tirar Foto Antes',
              ),
              const SizedBox(height: 20),

              // Fotos - Depois
              Text(
                'Foto Depois',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildFotoContainer(
                foto: _fotoDepois,
                onTap: () => _tirarFoto(false),
                label: 'Tirar Foto Depois',
              ),
              const SizedBox(height: 20),

              // Assinatura
              Text(
                'Assinatura do Cliente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Signature(
                    controller: _signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _signatureController.clear(),
                icon: const Icon(Icons.clear),
                label: const Text('Limpar Assinatura'),
              ),
              const SizedBox(height: 30),

              // Botão Salvar
              CustomButton(
                label: 'Salvar Ordem de Serviço',
                onPressed: _salvarOS,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFotoContainer({
    required XFile? foto,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: foto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(foto.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 48,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
