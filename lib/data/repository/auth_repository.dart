import 'package:edar_app/data/network/network_service.dart';

class AuthRepository {
  final NetworkService networkService;

  AuthRepository({required this.networkService});

  Future<String> login(Map<String, dynamic> userObject) async {
    final objRaw = await networkService.authenticate(userObject);
    dynamic jwt = objRaw["token"];

    return jwt;
  }
}
