class Validators {
  static String? stringNotEmpty(String value) =>
      value == null || value.isEmpty ? 'This field cannot be empty' : null;

  static String? numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }
}
