// core/utils/validators.dart

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  /// Egypt mobile examples:
  /// 010xxxxxxxx, 011xxxxxxxx, 012xxxxxxxx, 015xxxxxxxx
  /// +2010xxxxxxxx ... etc
  static final RegExp _egyptMobileRegex = RegExp(r'^(?:\+20|0)?1[0125]\d{8}$');

  static String _t(String? v) => (v ?? '').trim();

  // Required field validator (whitespace-safe)
  static String? required(
    String? value, {
    String? fieldName,
    String? message,
  }) {
    final v = _t(value);
    if (v.isEmpty) {
      if (message != null) return message;
      return fieldName != null
          ? 'Please enter $fieldName'
          : 'This field is required';
    }
    return null;
  }

  // Email validator
  static String? email(
    String? value, {
    String emptyMessage = 'Please enter your email',
    String invalidMessage = 'Please enter a valid email',
  }) {
    final v = _t(value);
    if (v.isEmpty) return emptyMessage;
    if (!_emailRegex.hasMatch(v)) return invalidMessage;
    return null;
  }

  // Password validator
  // strong=true => requires: upper, lower, number (and optional symbol if you want)
  static String? password(
    String? value, {
    int minLength = 6,
    bool strong = false,
    String emptyMessage = 'Please enter your password',
  }) {
    final v = _t(value);
    if (v.isEmpty) return emptyMessage;

    if (v.length < minLength) {
      return 'Password must be at least $minLength characters';
    }

    if (strong) {
      final hasUpper = RegExp(r'[A-Z]').hasMatch(v);
      final hasLower = RegExp(r'[a-z]').hasMatch(v);
      final hasNumber = RegExp(r'\d').hasMatch(v);
      // final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\]').hasMatch(v);

      if (!hasUpper || !hasLower || !hasNumber) {
        return 'Password must include upper, lower, and a number';
      }
    }

    return null;
  }

  // Name validator (supports Arabic + English letters)
  static String? name(
    String? value, {
    int minLength = 3,
    String emptyMessage = 'Please enter your name',
  }) {
    final v = _t(value);
    if (v.isEmpty) return emptyMessage;
    if (v.length < minLength)
      return 'Name must be at least $minLength characters';

    // Allow Arabic + Latin letters + spaces + common punctuation
    final nameRegex = RegExp(r"^[a-zA-Z\u0600-\u06FF\s'.-]+$");
    if (!nameRegex.hasMatch(v)) return 'Name contains invalid characters';

    return null;
  }

  // Phone validator (defaults to Egypt mobile validation if egyptOnly=true)
  static String? phone(
    String? value, {
    bool egyptOnly = true,
    String emptyMessage = 'Please enter your phone number',
    String invalidMessage = 'Please enter a valid phone number',
  }) {
    final v = _t(value);
    if (v.isEmpty) return emptyMessage;

    if (egyptOnly) {
      // Normalize spaces/hyphens just in case
      final normalized = v.replaceAll(RegExp(r'[\s\-()]'), '');
      if (!_egyptMobileRegex.hasMatch(normalized)) return invalidMessage;
      return null;
    }

    // Generic fallback
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 'Phone number must be at least 10 digits';
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(
    String? value,
    String? originalPassword, {
    String emptyMessage = 'Please confirm your password',
    String mismatchMessage = 'Passwords do not match',
  }) {
    final v = _t(value);
    if (v.isEmpty) return emptyMessage;
    if (v != (originalPassword ?? '')) return mismatchMessage;
    return null;
  }

  // Useful: min/max length
  static String? minLength(String? value, int min, {String? message}) {
    final v = _t(value);
    if (v.isEmpty) return null; // keep required() separate
    if (v.length < min) return message ?? 'Must be at least $min characters';
    return null;
  }

  static String? maxLength(String? value, int max, {String? message}) {
    final v = _t(value);
    if (v.isEmpty) return null;
    if (v.length > max) return message ?? 'Must be at most $max characters';
    return null;
  }

  // ===== VALIDATOR BUILDERS =====
  // Use these when you need custom parameters

  /// Returns a password validator with custom options
  /// Usage: validator: Validators.passwordBuilder(strong: true)
  static String? Function(String?) passwordBuilder({
    int minLength = 6,
    bool strong = false,
    String emptyMessage = 'Please enter your password',
  }) {
    return (value) => password(
          value,
          minLength: minLength,
          strong: strong,
          emptyMessage: emptyMessage,
        );
  }

  /// Returns an email validator with custom messages
  /// Usage: validator: Validators.emailBuilder(emptyMessage: 'Email required')
  static String? Function(String?) emailBuilder({
    String emptyMessage = 'Please enter your email',
    String invalidMessage = 'Please enter a valid email',
  }) {
    return (value) => email(
          value,
          emptyMessage: emptyMessage,
          invalidMessage: invalidMessage,
        );
  }

  /// Returns a phone validator with custom options
  /// Usage: validator: Validators.phoneBuilder(egyptOnly: false)
  static String? Function(String?) phoneBuilder({
    bool egyptOnly = true,
    String emptyMessage = 'Please enter your phone number',
    String invalidMessage = 'Please enter a valid phone number',
  }) {
    return (value) => phone(
          value,
          egyptOnly: egyptOnly,
          emptyMessage: emptyMessage,
          invalidMessage: invalidMessage,
        );
  }

  /// Returns a name validator with custom min length
  /// Usage: validator: Validators.nameBuilder(minLength: 2)
  static String? Function(String?) nameBuilder({
    int minLength = 3,
    String emptyMessage = 'Please enter your name',
  }) {
    return (value) => name(
          value,
          minLength: minLength,
          emptyMessage: emptyMessage,
        );
  }
}
