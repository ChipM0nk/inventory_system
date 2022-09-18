import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TextFieldFormat {
  static var bacthCodeFormat = MaskTextInputFormatter(
      mask: '####-##-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  static var amountFormat = FilteringTextInputFormatter.allow(RegExp("[.0-9]"));

  static var invoiceNoFormat;
}
