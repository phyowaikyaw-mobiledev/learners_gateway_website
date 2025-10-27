class InputValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Password must contain uppercase letter';
    if (!value.contains(RegExp(r'[a-z]'))) return 'Password must contain lowercase letter';
    if (!value.contains(RegExp(r'[0-9]'))) return 'Password must contain number';
    return null;
  }

  static String? validatePostTitle(String? value) {
    if (value == null || value.isEmpty) return 'Title is required';
    if (value.length < 5) return 'Title must be at least 5 characters';
    if (value.length > 100) return 'Title must be less than 100 characters';

    // Prevent XSS attempts
    if (value.contains('<script>') || value.contains('javascript:')) {
      return 'Invalid characters in title';
    }

    return null;
  }

  static String? validatePostContent(String? value) {
    if (value == null || value.isEmpty) return 'Content is required';
    if (value.length < 10) return 'Content must be at least 10 characters';
    if (value.length > 10000) return 'Content must be less than 10000 characters';

    // Basic XSS prevention
    final dangerousPatterns = [
      '<script', 'javascript:', 'onload=', 'onerror=', 'onclick='
    ];
    for (var pattern in dangerousPatterns) {
      if (value.toLowerCase().contains(pattern)) {
        return 'Invalid content detected';
      }
    }

    return null;
  }

  static String sanitizeInput(String input) {
    // Remove potentially dangerous characters
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }
}