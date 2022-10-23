import 'package:rxdart/rxdart.dart';

mixin ErrorMessageMixin {
  final _errorController = BehaviorSubject<String>();

  Stream<String> get errorStream => _errorController.stream;
  updateError(String? errorMessage) {
    print("Error encountered: $errorMessage");
    errorMessage = errorMessage ?? "Error encountered";
    _errorController.addError(errorMessage);
  }

  clearError() {
    _errorController.sink.add(""); //removes error message
  }
}
