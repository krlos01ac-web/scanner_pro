import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart'; 
import '../app_theme.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final List<String> _capturedImages = [];

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String?> _cropImage(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar Bordas',
          toolbarColor: AppTheme.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          activeControlsWidgetColor: AppTheme.actionColor,
        ),
        IOSUiSettings(title: 'Ajustar'),
      ],
    );
    return croppedFile?.path;
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      await _controller.pausePreview();
      
      final croppedPath = await _cropImage(image.path);
      
      await _controller.resumePreview();

      if (croppedPath == null) return;

      setState(() {
        _capturedImages.add(croppedPath);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Página ${_capturedImages.length} salva!'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  // ✅ AQUI ESTÁ A CORREÇÃO PRINCIPAL
  void _finishScanning() async {
    if (_capturedImages.isEmpty) return;

    // 1. Espera o resultado da tela de Preview
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(imagePaths: _capturedImages),
      ),
    );

    // 2. Se voltou uma lista (mesmo vazia), atualiza a câmera
    if (result != null && result is List<String>) {
      setState(() {
        _capturedImages.clear();
        _capturedImages.addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox.expand(child: CameraPreview(_controller)),
                
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: FloatingActionButton.large(
                      heroTag: "shoot",
                      backgroundColor: Colors.white,
                      onPressed: _takePicture,
                      child: const Icon(Icons.crop_free, color: Colors.black, size: 40),
                    ),
                  ),
                ),

                if (_capturedImages.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: FloatingActionButton.extended(
                        heroTag: "done",
                        backgroundColor: AppTheme.actionColor,
                        onPressed: _finishScanning,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: Text("(${_capturedImages.length})"),
                      ),
                    ),
                  ),
                
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}