// ignore_for_file: depend_on_referenced_packages, unused_import

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:edar_app/cubit/auth/auth_field_mixin.dart';
import 'package:edar_app/data/model/user.dart';
import 'package:edar_app/data/network/network_service.dart';
import 'package:edar_app/data/repository/auth_repository.dart';
import 'package:edar_app/local_storage.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/common/mixins/error_message_mixin.dart';
import 'package:edar_app/common/mixins/mixin_validations.dart';
import 'package:flutter/cupertino.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>
    with ValidationMixin, ErrorMessageMixin, AuthFieldMixin {
  User? _user;
  final AuthRepository authRepository =
      AuthRepository(networkService: NetworkService());

  AuthCubit() : super(AuthInitial());
  login() {
    User user = getCredentials();
    Map<String, dynamic> userObj = user.toJson();
    authRepository
        .login(userObj)
        .then(
          (jwt) async => {
            await LocalStorage.write("jwt", jwt),
            authenticate(),
          },
        )
        .onError(
          (error, stackTrace) => {updateError('$error')},
        );
  }

  logout() {
    LocalStorage.deletAll();
    authenticate();
    _user = null;
  }

  User getUserInfo() {
    return _user!;
  }

  authenticate() {
    LocalStorage.read("jwt").then((value) => {
          checkJwt(value),
        });
  }

  void checkJwt(String? jwt) {
    if (jwt == null) {
      emit(AuthenticationFailed());
    } else {
      String claims = jwt.split(".")[1];
      claims = utf8.decode(base64Url.decode(base64.normalize(claims)));
      Map<String, dynamic> userObj = jsonDecode(claims);
      User user = User.fromJson(userObj);
      _user = user;
      emit(AuthenticationSuccess());
    }
  }
}
