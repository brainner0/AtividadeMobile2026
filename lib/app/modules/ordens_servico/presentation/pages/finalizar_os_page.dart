import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

import '../../../../shared/mixins/loader_mixin.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../../models/ordem_servico_model.dart';
import '../../../../../repositories/ordem_servico_repository.dart';

/// Página para finalização da Ordem de Serviço
/// Deve ser acessada quando o técnico finalizar o serviço
/// Captura: Foto Depois + Assinatura do Cliente
class FinalizarOsPage extends StatefulWidget {
  final int ordemServicoId;

  const FinalizarOsPage({
    super.key,
    required this.ordemServicoId,
  });

  @override
  State<FinalizarOsPage> createState() => _FinalizarOsPageState();
}

class _FinalizarOsPageState extends State<FinalizarOsPage> with LoaderMixin {
  final ImagePicker _imagePicker = ImagePicker();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final OrdemServicoRepository _osRepository = OrdemServicoRepository();

  OrdemServicoModel? _ordemServico;
  XFile? _fotoDepois;
  bool _assinaturaConfirmada = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarOrdemServico();
  }

  Future<void> _carregarOrdemServico() async {
    try {
      final os = await _osRepository.buscarPorId(widget.ordemServicoId);
      if (os == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ordem de serviço não encontrada'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pop();
        }
        return;
      }

      setState(() {
        _ordemServico = os;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar OS: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _tirarFotoDepois() async {
    try {
      final XFile? foto = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (foto != null) {
        setState(() {
          _fotoDepois = foto;
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

  void _removerFotoDepois() {
    setState(() {
      _fotoDepois = null;
    });
  }

  void _limparAssinatura() {
    setState(() {
      _assinaturaConfirmada = false;
    });
    _signatureController.clear();
  }

  void _confirmarAssinatura() {
    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, assine no canvas abaixo')),
      );
      return;
    }

    setState(() {
      _assinaturaConfirmada = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Assinatura confirmada!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _finalizarOS() async {
    if (_ordemServico == null) return;

    // Validar foto depois
    if (_fotoDepois == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tire a foto depois do serviço')),
      );
      return;
    }

    // Validar assinatura
    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A assinatura do cliente é obrigatória')),
      );
      return;
    }

    if (!_assinaturaConfirmada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Confirme a assinatura do cliente')),
      );
      return;
    }

    try {
      showLoader();

      // Salvar assinatura como arquivo temporário
      final assinaturaBytes = await _signatureController.toPngBytes();
      if (assinaturaBytes == null) {
        throw Exception('Erro ao processar assinatura');
      }

      // Criar arquivo temporário para a assinatura
      final tempDir = Directory.systemTemp;
      final assinaturaFile = File('${tempDir.path}/assinatura_${_ordemServico!.id}.png');
      await assinaturaFile.writeAsBytes(assinaturaBytes);

      // Finalizar OS no banco
      await _osRepository.finalizar(
        _ordemServico!.id!,
        _fotoDepois!.path,
        assinaturaFile.path,
      );

      hideLoader();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ordem de Serviço finalizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Voltar para o menu principal
        Navigator.of(context).pop();
      }
    } catch (e) {
      hideLoader();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao finalizar OS: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Finalizar OS'),
          backgroundColor: theme.primaryColor,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_ordemServico == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Finalizar OS'),
          backgroundColor: theme.primaryColor,
        ),
        body: const Center(
          child: Text('Ordem de serviço não encontrada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar OS'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Informações da OS
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Cliente: ${_ordemServico!.clienteNome}',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Telefone: ${_ordemServico!.clienteTelefone}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Valor: R\$ ${_ordemServico!.valor.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Descrição: ${_ordemServico!.descricao}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Foto Antes (apenas visualização)
            Text(
              'Foto Antes',
              style: theme.textTheme.titleMedium,
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
                child: Image.file(
                  File(_ordemServico!.fotoAntesPath),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.image_not_supported, size: 48),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Foto Depois (obrigatória)
            Text(
              'Foto Depois *',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildFotoDepoisContainer(),
            const SizedBox(height: 20),

            // Assinatura do Cliente
            Text(
              'Assinatura do Cliente *',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildAssinaturaContainer(theme),
            const SizedBox(height: 30),

            // Botão Finalizar
            CustomButton(
              label: 'Finalizar Ordem de Serviço',
              onPressed: _finalizarOS,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoDepoisContainer() {
    if (_fotoDepois != null) {
      return GestureDetector(
        onTap: _removerFotoDepois,
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
                  File(_fotoDepois!.path),
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
      onTap: _tirarFotoDepois,
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
              'Tirar Foto Depois',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Clique para capturar',
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

  Widget _buildAssinaturaContainer(ThemeData theme) {
    if (_assinaturaConfirmada) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.green, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Signature(
              controller: _signatureController,
              backgroundColor: Colors.white,
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
                      'Assinatura confirmada',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _limparAssinatura,
              icon: const Icon(Icons.clear),
              label: const Text('Limpar'),
            ),
            ElevatedButton.icon(
              onPressed: _confirmarAssinatura,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar Assinatura'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}