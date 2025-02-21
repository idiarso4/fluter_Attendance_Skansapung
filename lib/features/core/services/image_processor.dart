import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:intl/intl.dart';

class ImageProcessor {
  static const int maxWidth = 1024;
  static const int compressionQuality = 80;
  static const String watermarkDateFormat = 'yyyy-MM-dd HH:mm:ss';
  static const double faceDetectionConfidence = 0.7;
  static final _faceDetector = GoogleMlKit.vision.faceDetector(
    FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
      minFaceSize: 0.15,
    )
  );

  static Future<File> processAttendancePhoto(File photo, {bool requireFace = true}) async {
    File? tempFile;
    try {
      if (!await photo.exists()) {
        throw Exception('Source photo file does not exist');
      }

      // Detect faces if required
      if (requireFace) {
        final inputImage = InputImage.fromFile(photo);
        final faces = await _faceDetector.processImage(inputImage);
        
        if (faces.isEmpty) {
          throw Exception('No face detected in the photo');
        }
        
        if (faces.length > 1) {
          throw Exception('Multiple faces detected in the photo');
        }
        
        final face = faces.first;
        if (face.headEulerAngleY != null && 
            (face.headEulerAngleY! < -15 || face.headEulerAngleY! > 15)) {
          throw Exception('Face is not properly aligned (too much side angle)');
        }
      }

      // Read and validate the image file
      final bytes = await photo.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image: Invalid image format');
      }

      // Optimize image size while maintaining quality
      var processedImage = image;
      if (image.width > maxWidth) {
        processedImage = img.copyResize(
          image,
          width: maxWidth,
          maintainAspect: true,
          interpolation: img.Interpolation.linear,
        );
      }

      // Add watermark with formatted timestamp
      final timestamp = DateFormat(watermarkDateFormat).format(DateTime.now());
      final watermarked = await _addWatermark(processedImage, timestamp);
      
      // Optimize compression for balance of size and quality
      final compressedBytes = img.encodeJpg(watermarked, quality: compressionQuality);
      
      // Create temp file with unique name
      final tempDir = Directory.systemTemp;
      tempFile = File('${tempDir.path}/attendance_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      return tempFile;
    } catch (e) {
      // Clean up temp file if exists
      if (tempFile != null && await tempFile.exists()) {
        await tempFile.delete();
      }
      throw Exception('Failed to process photo: $e');
    }
  }

  static Future<img.Image> _addWatermark(img.Image image, String text) async {
    final watermarked = img.copyResize(image, width: image.width);
    
    // Add semi-transparent background for better text visibility
    const textBgWidth = 220;
    const textBgHeight = 40;
    final bgX = watermarked.width - textBgWidth;
    final bgY = watermarked.height - textBgHeight;
    
    for (var y = bgY; y < watermarked.height; y++) {
      for (var x = bgX; x < watermarked.width; x++) {
        final pixel = watermarked.getPixel(x, y);
        watermarked.setPixel(x, y, img.ColorRgba8(
          pixel.r.toInt(),
          pixel.g.toInt(),
          pixel.b.toInt(),
          128, // Semi-transparent background
        ));
      }
    }
    
    // Add timestamp watermark with improved visibility
    img.drawString(
      watermarked,
      text,
      font: img.arial24,
      x: watermarked.width - 210,
      y: watermarked.height - 30,
      color: img.ColorRgb8(255, 255, 255), // White text
    );
    
    return watermarked;
  }
}