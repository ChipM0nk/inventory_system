// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:edar_app/constants/constants.dart';
import 'package:edar_app/local_storage.dart';
import 'package:http/http.dart';

class NetworkService {
  Future<dynamic> authenticate(Map<String, dynamic> userObj) async {
    String url = "$BASE_URL/authenticate/";

    final response = await post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userObj));
    dynamic respObj = jsonDecode(response.body);
    if (respObj['code'] == '000') {
      dynamic respBody = respObj['body'];
      return respBody;
    }

    throw Exception(respObj['message']);
  }

  Future<List<dynamic>> fetchWithParam(
      String serviceName, Map<String, dynamic> paramObj) async {
    try {
      String url = "$BASE_URL$serviceName/all/param";

      final response = await post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${await LocalStorage.read("jwt")}",
          },
          body: jsonEncode(paramObj));
      dynamic respObj = jsonDecode(response.body);
      print(json.encode(respObj));
      if (respObj['code'] == '000') {
        List<dynamic> respBody = respObj['body'];
        return respBody;
      }

      throw Exception(respObj['message']);
    } catch (e) {
      print("Error: ${e}");
    }
    return [];
  }

  Future<List<dynamic>> fetchAll(String serviceName) async {
    try {
      String url = "$BASE_URL$serviceName/all";

      final response = await get(Uri.parse(url), headers: {
        'Authorization': "Bearer ${await LocalStorage.read("jwt")}"
      });
      dynamic respObj = jsonDecode(response.body);
      print(json.encode(respObj));
      if (respObj['code'] == '000') {
        List<dynamic> respBody = respObj['body'];
        return respBody;
      }

      throw Exception(respObj['message']);
    } catch (e) {
      print("Error: ${e}");
    }
    return [];
  }

  Future<bool> addItem(
    Map<String, dynamic> addObj,
    String serviceName,
  ) async {
    // try {
    print("Adding item");
    String url = "$BASE_URL$serviceName/add";
    print(addObj);
    final response = await post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await LocalStorage.read("jwt")}",
        },
        body: jsonEncode(addObj));
    dynamic respObj = jsonDecode(response.body);
    if (respObj['code'] == '000') {
      return true;
    }
    print('Error Code: ${respObj["code"]}');
    throw Exception(respObj['message']);
  }

  Future<bool> udpateItem(
      Map<String, dynamic> categoryObj, int id, String serviceName) async {
    print("Updating item");
    String url = "$BASE_URL$serviceName/update";

    final response = await patch(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${await LocalStorage.read("jwt")}",
        },
        body: jsonEncode(categoryObj));
    dynamic respObj = jsonDecode(response.body);
    if (respObj['code'] == '000') {
      return true;
    }
    throw Exception(respObj['message']);
  }

  Future<bool> deleteItem(int id, String serviceName) async {
    print("Deleting item");
    String url = "$BASE_URL$serviceName/delete/$id";

    final response = await delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer ${await LocalStorage.read("jwt")}",
      },
    );
    dynamic respObj = jsonDecode(response.body);
    if (respObj['code'] == '000') {
      return true;
    }
    throw Exception(respObj['message']);
  }
}
