mixin ValidationMixin {
  bool isFieldEmpty(String fieldValue) => fieldValue.trim().isEmpty;

  bool validTextLength(String fieldValue, int length) =>
      fieldValue.trim().length >= length;

  bool validateEmailAddress(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isFieldNumeric(String fieldValue) {
    return num.tryParse(fieldValue) != null;
  }

  bool isFieldDoubleNumeric(String s) {
    return double.tryParse(s) != null;
  }
}

/// Define an extension:
extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
