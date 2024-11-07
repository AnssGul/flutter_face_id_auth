// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:hive/hive.dart';
// import 'dart:typed_data';

// class FaceVerificationScreen extends StatefulWidget {
//   const FaceVerificationScreen({super.key});

//   @override
//   _FaceVerificationScreenState createState() => _FaceVerificationScreenState();
// }

// class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
//   CameraController? _cameraController;
//   FaceDetector? _faceDetector;
//   bool _isProcessing = false;
//   bool _isMatched = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//     _faceDetector = GoogleMlKit.vision.faceDetector();
//   }

//   Future<void> _initializeCamera() async {
//     final cameras = await availableCameras();
//     final camera = cameras.firstWhere(
//         (camera) => camera.lensDirection == CameraLensDirection.front);
//     _cameraController = CameraController(camera, ResolutionPreset.medium);
//     await _cameraController!.initialize();
//     _cameraController!.startImageStream(_processCameraImage);
//   }

//   void _processCameraImage(CameraImage image) async {
//     if (_isProcessing) return;
//     _isProcessing = true;

//     final inputImage = InputImage.fromBytes(
//       bytes: image.planes[0].bytes,
//       inputImageData: InputImageData(
//         size: Size(image.width.toDouble(), image.height.toDouble()),
//         imageRotation: InputImageRotation.rotation0,
//         inputImageFormat: InputImageFormat.yuv420,
//         planeData: image.planes
//             .map((plane) => InputImagePlaneMetadata(
//                   bytesPerRow: plane.bytesPerRow,
//                   height: plane.height,
//                   width: plane.width,
//                 ))
//             .toList(),
//       ),
//     );

//     final faces = await _faceDetector!.processImage(inputImage);
//     if (faces.isNotEmpty) {
//       final box = await Hive.openBox('faceData');
//       final profileImageBytes = box.get('profileImage');

//       if (await _compareFaces(profileImageBytes, faces[0])) {
//         setState(() => _isMatched = true);
//         Navigator.of(context).pushReplacementNamed('/home');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Face not recognized. Try again.')));
//       }
//     }
//     _isProcessing = false;
//   }

//   Future<bool> _compareFaces(Uint8List profileImage, Face detectedFace) async {
//     return true;
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     _faceDetector?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Face Verification')),
//       body: Stack(
//         children: [
//           _cameraController != null
//               ? CameraPreview(_cameraController!)
//               : Center(child: CircularProgressIndicator()),
//           if (!_isMatched)
//             Center(child: Text('Position your face in the frame')),
//         ],
//       ),
//     );
//   }
// }
