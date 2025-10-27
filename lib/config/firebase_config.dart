class FirebaseConfig {
  static const String apiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
  static const String projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const List<String> adminEmails = [
    'admin@yourdomain.com',
    'superadmin@yourdomain.com',
  ];

  static bool isAdmin(String email) {
    return adminEmails.contains(email);
  }
}