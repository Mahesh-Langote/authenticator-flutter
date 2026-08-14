import 'package:otp/otp.dart';

class OtpUtil {
  static String generateTotp(String secret) {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      return OTP.generateTOTPCodeString(
        secret,
        now,
        length: 6,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
    } catch (e) {
      return '------';
    }
  }

  static double getProgressIndicatorValue() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final int seconds = (now / 1000).round() % 30;
    return 1 - (seconds / 30.0);
  }

  static int getRemainingSeconds() {
    final now = DateTime.now().millisecondsSinceEpoch;
    return 30 - ((now / 1000).round() % 30);
  }
}
