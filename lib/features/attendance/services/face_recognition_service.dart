import 'dart:typed_data';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:math' show Point, sqrt;

class FaceRecognitionService {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );

  Future<bool> detectLiveness(CameraImage image) async {
    final inputImage = await _convertCameraImage(image);
    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) return false;

    final face = faces.first;
    final leftEyeOpen = face.leftEyeOpenProbability ?? 0;
    final rightEyeOpen = face.rightEyeOpenProbability ?? 0;

    return _validateLiveness(leftEyeOpen, rightEyeOpen);
  }

  Future<double> compareFaces(InputImage currentFace, InputImage referenceFace) async {
    final currentFaces = await _faceDetector.processImage(currentFace);
    final referenceFaces = await _faceDetector.processImage(referenceFace);

    if (currentFaces.isEmpty || referenceFaces.isEmpty) {
      return 0.0;
    }

    return _calculateFaceSimilarity(
      currentFaces.first,
      referenceFaces.first,
    );
  }

  bool _validateLiveness(double leftEye, double rightEye) {
    const double closedThreshold = 0.2;  // Threshold for considering eyes closed
    const double minOpenness = 0.05;     // Minimum openness to prevent complete closure (anti-spoofing)
    const double maxAsymmetry = 0.15;    // Maximum allowed asymmetry between eyes

    // Check if both eyes are closed (blink detection)
    bool areBothEyesClosed = leftEye < closedThreshold && rightEye < closedThreshold;
    
    // Prevent complete eye closure (anti-spoofing)
    bool hasMinimalOpenness = leftEye > minOpenness && rightEye > minOpenness;
    
    // Check for natural eye symmetry (anti-spoofing)
    bool hasNaturalSymmetry = (leftEye - rightEye).abs() <= maxAsymmetry;
    
    // Combined validation for natural blink pattern
    return areBothEyesClosed && hasMinimalOpenness && hasNaturalSymmetry;
  }

  double _calculateFaceSimilarity(Face face1, Face face2) {
    double similarity = 0.0;
    double totalWeight = 0.0;
    
    // Compare face angles with weight 0.3
    if (face1.headEulerAngleY != null && face2.headEulerAngleY != null) {
      double angleDiff = (face1.headEulerAngleY! - face2.headEulerAngleY!).abs();
      similarity += 0.3 * (1.0 - (angleDiff / 90.0));
      totalWeight += 0.3;
    }
    
    // Compare face landmarks with weight 0.7
    if (face1.landmarks.isNotEmpty && face2.landmarks.isNotEmpty) {
      double landmarkSimilarity = 0.0;
      int totalLandmarks = 0;
      
      for (var landmark1 in face1.landmarks.entries) {
        for (var landmark2 in face2.landmarks.entries) {
          if (landmark1.key == landmark2.key && 
              landmark1.value != null && 
              landmark2.value != null) {
            totalLandmarks++;
            double distance = _calculateLandmarkDistance(
              landmark1.value!.position,
              landmark2.value!.position
            );
            // Convert distance to similarity score (0-1)
            double pointSimilarity = 1.0 - (distance / 100.0).clamp(0.0, 1.0);
            landmarkSimilarity += pointSimilarity;
          }
        }
      }
      
      if (totalLandmarks > 0) {
        similarity += 0.7 * (landmarkSimilarity / totalLandmarks);
        totalWeight += 0.7;
      }
    }
    
    // Normalize similarity score based on total weight
    return totalWeight > 0 ? (similarity / totalWeight).clamp(0.0, 1.0) : 0.0;
  }

  double _calculateLandmarkDistance(Point<int> point1, Point<int> point2) {
    double dx = point1.x.toDouble() - point2.x.toDouble();
    double dy = point1.y.toDouble() - point2.y.toDouble();
    return sqrt(dx * dx + dy * dy);
  }

  Future<InputImage> _convertCameraImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    const imageRotation = InputImageRotation.rotation0deg;
    const inputImageFormat = InputImageFormat.bgra8888;

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: metadata,
    );
  }
}