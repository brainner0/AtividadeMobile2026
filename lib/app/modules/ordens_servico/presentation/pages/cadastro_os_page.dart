import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../clientes/cliente.model.dart';
import '../../../../shared/mixins/loader_mixin.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import 'finalizar_os_page.dart';

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

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _clienteDropdown.dispose();
    super.dispose();
  }

  Future<void> _tirarFotoAntes() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (foto != null) {
        setState(() {
          _fotoAntes = foto;
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

  void _removerFotoAntes() {
    setState(() {
      _fotoAntes = null;
    });
  }

  Future<void> _salvarOS() async {
    if (!_formKey.currentState!.validate()) return;

    if (_clienteSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um cliente')),
      );
      return;
    }

    // Foto antes é obrigatória
    if (_fotoAntes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire a foto antes do serviço')),
      );
      return;
    }

    // Exibir LoaderMixin por 2 segundos
    showLoader();
    await Future.delayed(const Duration(seconds: 2));
    hideLoader();

    // Navegar para página de finalização
    if (mounted) {
      final resultado = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => FinalizarOsPage(
            ordemServicoId: 'OS-${DateTime.now().millisecondsSinceEpoch}',
            clienteNome: _clienteSelecionado!.nome,
            fotoAntesPath: _fotoAntes!.path,
          ),
        ),
      );

      if (resultado == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ordem de Serviço concluída com sucesso!'),
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
        });
      }
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
                'Foto Antes *',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _buildFotoAntesContainer(),
              const SizedBox(height: 30),

              // Botão Salvar
              CustomButton(
                label: 'Salvar e Finalizar OS',
                onPressed: _salvarOS,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFotoAntesContainer() {
    if (_fotoAntes != null) {
      return GestureDetector(
        onTap: _removerFotoAntes,
        child: Stack(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_fotoAntes!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Foto capturada',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _tirarFotoAntes,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 48,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              'Tirar Foto Antes',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Clique para capturar o estado inicial',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
