import 'dart:io';
import 'package:image/image.dart' as img;

class ImageProcessor {
  static Future<File> processAttendancePhoto(File photo) async {
    try {
      // Read the image file
      final bytes = await photo.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize image if it's too large (max width 1024px)
      var processedImage = image;
      if (image.width > 1024) {
        processedImage = img.copyResize(
          image,
          width: 1024,
          maintainAspect: true,
        );
      }

      // Compress and save the image
      final compressedBytes = img.encodeJpg(processedImage, quality: 85);
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/processed_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      throw Exception('Failed to process photo: $e');
    }
  }
}