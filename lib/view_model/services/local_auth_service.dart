import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static final _auth = LocalAuthentication();

  static Future<bool> canAuthenticate () async  =>
      await _auth.canCheckBiometrics || await _auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;
      return await _auth.authenticate(
          localizedReason: 'Authentifiez vous pour pouvoir accéder à l\'application',
          // authMessages: <AuthMessages> [
          //   AndroidAuthMessages(
          //     signInTitle: 'Oops! Biometric authentication required!',
          //     cancelButton: 'No thanks',
          //   ),
          //   IOSAuthMessages(
          //     cancelButton: 'No thanks',
          //   ),
          // ]
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true
        )
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}