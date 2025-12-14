import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class PdfService {
  Future<File> generatePdf(List<String> imagePaths, int filterIndex) async {
    final pdf = pw.Document();

    for (var path in imagePaths) {
      final file = File(path);
      Uint8List imageBytes = await file.readAsBytes();

      // Só processa se o filtro NÃO for o Original (0)
      if (filterIndex != 0) {
        try {
          img.Image? originalImage = img.decodeImage(imageBytes);

          if (originalImage != null) {
            // Otimização de tamanho
            if (originalImage.width > 1000) {
              originalImage = img.copyResize(originalImage, width: 1000);
            }

            // ✅ SE FOR O FILTRO 1 (P&B), APLICA O EFEITO
            if (filterIndex == 1) {
              originalImage = img.grayscale(originalImage);
            }

            imageBytes = Uint8List.fromList(img.encodeJpg(originalImage, quality: 85));
          }
        } catch (e) {
          print("Erro ao aplicar filtro: $e");
        }
      }

      final pdfImage = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage),
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final fileName = "scan_${DateTime.now().millisecondsSinceEpoch}.pdf";
    final file = File("${output.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }
}