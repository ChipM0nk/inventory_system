import 'package:bloc/bloc.dart';
import 'package:edar_app/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(LoginAuthInitial());

  final storage = new FlutterSecureStorage();
  login() async {
    print("Logged in");
    await LocalStorage.write("key", "value");
    authenticate();
  }

  logout() async {
    await LocalStorage.deletAll();
    authenticate();
  }

  authenticate() async {
    String? value = await LocalStorage.read("key");

    if (value == null) {
      emit(AuthenticationFailed());
    } else {
      emit(AuthenticationSuccess());
    }
  }
}
