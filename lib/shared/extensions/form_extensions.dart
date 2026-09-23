import 'package:flutter/services.dart';

/// Input sanitization helpers shared by every form in the app.
extension FormStringX on String? {
  /// Trimmed value with control characters stripped, or '' when null.
  String get sanitized {
    final v = this ?? '';
    return v.replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), '').trim();
  }

  String? requireNonEmpty([String? field]) {
    if (sanitized.isEmpty) return 'Please enter ${field ?? 'this field'}';
    return null;
  }
}

/// [TextInputFormatter] that strips control characters while typing so
/// malicious payloads never even reach the validator.
class SanitizeFormatter extends TextInputFormatter {
  static final _control = RegExp(r'[\u0000-\u001F\u007F]');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!_control.hasMatch(newValue.text)) return newValue;
    final cleaned = newValue.text.replaceAll(_control, '');
    return TextEditingValue(
      text: cleaned,
      selection: TextSelection.collapsed(offset: cleaned.length),
    );
  }
}
