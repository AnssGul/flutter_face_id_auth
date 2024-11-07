// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:typed_data';

// class UploadProfilePictureScreen extends StatefulWidget {
//   @override
//   _UploadProfilePictureScreenState createState() =>
//       _UploadProfilePictureScreenState();
// }

// class _UploadProfilePictureScreenState
//     extends State<UploadProfilePictureScreen> {
//   Uint8List? _profileImage;

//   Future<void> _pickImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(source: ImageSource.gallery);

//     if (pickedImage != null) {
//       final imageBytes = await pickedImage.readAsBytes();
//       setState(() => _profileImage = imageBytes);
//       final box = await Hive.openBox('faceData');
//       box.put('profileImage', imageBytes);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Profile Picture')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _profileImage != null
//                 ? Image.memory(_profileImage!, width: 150, height: 150)
//                 : Icon(Icons.person, size: 150),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Upload Profile Picture'),
//             ),
//             if (_profileImage != null)
//               ElevatedButton(
//                 onPressed: () => Navigator.of(context).pushNamed('/verify'),
//                 child: Text('Proceed to Verification'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
