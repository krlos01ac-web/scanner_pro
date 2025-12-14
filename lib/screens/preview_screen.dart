import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../services/pdf_service.dart';
import '../app_theme.dart';
import '../widgets/ad_banner.dart';

class PreviewScreen extends StatefulWidget {
  final List<String> imagePaths;

  const PreviewScreen({super.key, required this.imagePaths});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final PdfService _pdfService = PdfService();
  bool _isGenerating = false;
  late List<String> _currentImages;
  
  // 0 = Original, 1 = Preto e Branco
  int _selectedFilterIndex = 0;

  // REMOVIDO O FILTRO ECO DA LISTA
  final List<List<double>> _filters = [
    // 0. Original
    [1,0,0,0,0, 0,1,0,0,0, 0,0,1,0,0, 0,0,0,1,0], 
    // 1. P&B (Escala de Cinza)
    [0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0.2126,0.7152,0.0722,0,0, 0,0,0,1,0], 
  ];

  @override
  void initState() {
    super.initState();
    _currentImages = List.from(widget.imagePaths);
  }

  void _deletePage(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir página?"),
        content: const Text("Essa ação não pode ser desfeita."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentImages.removeAt(index);
              });
              
              if (_currentImages.isEmpty) {
                Navigator.pop(context, _currentImages);
              }
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePdf() async {
    if (_currentImages.isEmpty) return;
    setState(() => _isGenerating = true);
    try {
      final pdfFile = await _pdfService.generatePdf(_currentImages, _selectedFilterIndex);
      await Share.shareXFiles(
        [XFile(pdfFile.path)],
        text: 'Documento escaneado (Scanner Pro)',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _currentImages);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Documento (${_currentImages.length} pág)"),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _currentImages),
          ),
          actions: [
            TextButton(
              onPressed: (_isGenerating || _currentImages.isEmpty) ? null : _sharePdf,
              child: Text(
                _isGenerating ? "..." : "COMPARTILHAR",
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.actionColor),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _currentImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Página ${index + 1}", 
                              style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 32),
                              onPressed: () => _deletePage(index),
                              tooltip: "Remover página",
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                            )
                          ],
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.matrix(_filters[_selectedFilterIndex]),
                            child: Image.file(File(_currentImages[index])),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // ✅ BARRA DE FILTROS AGORA SÓ TEM 2 OPÇÕES
            Container(
              height: 100,
              color: const Color(0xFF1E1E1E),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButton(0, "Original"),
                  _buildFilterButton(1, "Preto & Branco"),
                  // O botão Eco foi removido daqui
                ],
              ),
            ),
            const SafeArea(child: AdBanner()),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return TextButton(
      onPressed: () => setState(() => _selectedFilterIndex = index),
      child: Text(label, style: TextStyle(
        color: isSelected ? AppTheme.actionColor : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 16, // Aumentei um pouco a fonte já que tem mais espaço
      )),
    );
  }
}