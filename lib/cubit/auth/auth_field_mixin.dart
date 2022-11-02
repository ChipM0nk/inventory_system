// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:edar_app/data/model/user.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

@immutable
mixin AuthFieldMixin on ValidationMixin {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  init() {
    _usernameController.sink.addError("");
    _passwordController.sink.addError("");
  }

  Stream<String> get usernameStream => _usernameController.stream;
  udpateUsername(String fieldValue) {
    if (validTextLength(fieldValue, 3)) {
      _usernameController.sink.add(fieldValue);
    } else {
      _usernameController.sink
          .addError("Please enter text with length greater than 3");
    }
  }

  Stream<String> get passwordStream => _passwordController.stream;
  udpatePassword(String fieldValue) {
    if (validTextLength(fieldValue, 3)) {
      _passwordController.sink.add(fieldValue);
    } else {
      _passwordController.sink
          .addError("Please enter text with length greater than 3");
    }
  }

  Stream<bool> get buttonValid =>
      Rx.combineLatest2(usernameStream, passwordStream, (a, b) => true);

  User getCredentials() {
    return User(
      username: _usernameController.value,
      password: _passwordController.value,
    );
  }
}
