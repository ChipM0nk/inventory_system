import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin ErrorMessageMixin {
  final _errorController = BehaviorSubject<String>();
  final Logger LOG = Logger();

  Stream<String> get errorStream => _errorController.stream;
  updateError(String? errorMessage, StackTrace? stackTrace) {
    errorMessage = errorMessage ?? "Error encountered";
    _errorController.addError(errorMessage);
    if (stackTrace != null) {
      _printStacktrace(stackTrace);
    }
  }

  clearError() {
    _errorController.sink.add(""); //removes error message
  }

  _printStacktrace(StackTrace stackTrace) {
    print(stackTrace.toString());
    LOG.log(Level.error, stackTrace);
  }
}
