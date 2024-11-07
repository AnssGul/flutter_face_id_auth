import 'package:face_id_recongination/auth_face_id.dart';
import 'package:face_id_recongination/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => FaceAuthPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class FaceAuthPage extends StatefulWidget {
  @override
  FaceAuthPageState createState() => FaceAuthPageState();
}

class FaceAuthPageState extends State<FaceAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  Rect? _faceRect;

  Future<void> _authenticate() async {
    setState(() {
      _isAuthenticating = true;
    });

    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();
        if (availableBiometrics.contains(BiometricType.face)) {
          AuthenticationResult result = await auth.authenticate(
            localizedReason:
                'Please authenticate with Face ID to access the app',
            options: const AuthenticationOptions(
              biometricOnly: true,
              useErrorDialogs: true,
              stickyAuth: true,
            ),
            authenticationMessages: const [
              AuthenticationMessage(
                title: 'Face Authentication',
                description: 'Please position your face within the circle',
              ),
            ],
          );

          if (result.authenticated) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Authentication failed')),
            );
          }

          setState(() {
            _isAuthenticating = false;
            _faceRect = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Face ID not supported. Using other biometrics."),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Biometric authentication is not enabled on this device."),
          ),
        );
      }
    } catch (e) {
      print('Error during authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred during authentication'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
        _faceRect = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Recognition Login')),
      body: Stack(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: _authenticate,
              child: const Text('Authenticate with Face ID'),
            ),
          ),
          if (_isAuthenticating && _faceRect != null)
            Positioned(
              left: _faceRect?.left,
              top: _faceRect?.top,
              width: _faceRect?.width,
              height: _faceRect?.height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 4),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
