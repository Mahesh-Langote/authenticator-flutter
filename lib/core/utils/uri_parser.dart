class UriParser {
  static Map<String, String>? parseOtpAuthUri(String uriString) {
    try {
      final uri = Uri.parse(uriString);
      if (uri.scheme != 'otpauth' || uri.host != 'totp') {
        return null; // Only support TOTP for now
      }

      String accountName = '';
      String issuer = '';

      // The path typically contains /Issuer:AccountName or /AccountName
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        final path = Uri.decodeComponent(pathSegments.first);
        if (path.contains(':')) {
          final parts = path.split(':');
          issuer = parts[0].trim();
          accountName = parts[1].trim();
        } else {
          accountName = path.trim();
        }
      }

      final secret = uri.queryParameters['secret'];
      if (secret == null || secret.isEmpty) {
        return null;
      }

      // Query param issuer overrides path issuer
      final queryIssuer = uri.queryParameters['issuer'];
      if (queryIssuer != null && queryIssuer.isNotEmpty) {
        issuer = queryIssuer;
      }

      return {
        'accountName': accountName,
        'issuer': issuer,
        'secret': secret,
      };
    } catch (e) {
      return null;
    }
  }
}
