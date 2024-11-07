import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FaceAuthPage extends StatefulWidget {
  @override
  _FaceAuthPageState createState() => _FaceAuthPageState();
}

class _FaceAuthPageState extends State<FaceAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool isAuthenticated = false;

    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await auth.getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.face)) {
          isAuthenticated = await auth.authenticate(
            localizedReason:
                'Please authenticate with Face ID to access the app',
            options: const AuthenticationOptions(biometricOnly: true),
          );
        } else if (availableBiometrics.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text("Face ID not supported. Using other biometrics.")),
          );

          isAuthenticated = await auth.authenticate(
            localizedReason: 'Please authenticate to access the app',
            options: const AuthenticationOptions(biometricOnly: true),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "No biometric authentication available on this device.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "Biometric authentication is not enabled on this device.")),
        );
      }

      if (isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } catch (e) {
      print('Error during authentication: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred during authentication')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Recognition Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _authenticate,
          child: const Text('Authenticate with Face ID'),
        ),
      ),
    );
  }
}
