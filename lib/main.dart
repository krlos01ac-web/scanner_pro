import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/camera_screen.dart';
import 'widgets/ad_banner.dart'; // ✅ Importante
import 'app_theme.dart'; // <--- Adicione esta linha
import 'screens/paywall_screen.dart';

// Inicializa como lista vazia para evitar crash se a câmera falhar
List<CameraDescription> _cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // INICIALIZA OS ANÚNCIOS
  await MobileAds.instance.initialize(); 

  // Detecta as câmeras
  try {
    _cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Erro na câmera: $e');
  }

  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scanner+',
      debugShowCheckedModeBanner: false,
      
      // ✅ APLICANDO O NOVO TEMA AQUI
      theme: AppTheme.lightTheme, 
      
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  Future<void> _requestPermissions() async {
    await [Permission.camera, Permission.storage].request();
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  void _openCamera() {
    if (_cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma câmera encontrada!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(camera: _cameras.first),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SCANNER PRO"),
        actions: [
          // Botão PRO (Coroa)
          IconButton(
            icon: const Icon(Icons.workspace_premium, color: AppTheme.actionColor), // Coroa Laranja
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaywallScreen()),
              );
            },
          ),
          // Botão Configurações (antigo)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, 
          )
        ],
      ),  
        
      
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: AdBanner(),
        ),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Círculo decorativo
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.document_scanner_rounded, 
                size: 100, 
                color: AppTheme.primaryColor
              ),
            ),
            const SizedBox(height: 30),
            
            Text(
              "Digitalize seus papéis",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            const Text(
              "Toque abaixo para começar",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            
            // Botão Principal Grande
            ElevatedButton.icon(
              onPressed: _openCamera,
              icon: const Icon(Icons.camera_alt),
              label: const Text("NOVO SCANNER"),
            ),
          ],
        ),
      ),
    );
  }}