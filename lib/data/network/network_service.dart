// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:edar_app/constants/strings.dart';
import 'package:http/http.dart';

class NetworkService {
  Future<List<dynamic>> fetchAll(String serviceName) async {
    try {
      String url = "$BASE_URL$serviceName/all";
      final response = await get(Uri.parse(url));
      dynamic respObj = jsonDecode(response.body);
      print(respObj);
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

    final response = await post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(addObj));
    dynamic respObj = jsonDecode(response.body);
    if (respObj['code'] == '000') {
      return true;
    }
    print('Error Code: ${respObj["code"]}');
    throw Exception(respObj['message']);
    // } catch (e) {
    //   print("Error encountered: ${e}");
    // }
    // return false;
  }

  Future<bool> udpateItem(
      Map<String, dynamic> categoryObj, int id, String serviceName) async {
    try {
      print("Updating item");
      String url = "$BASE_URL$serviceName/update";

      final response = await patch(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(categoryObj));
      dynamic respObj = jsonDecode(response.body);
      if (respObj['code'] == '000') {
        return true;
      }
      throw Exception(respObj['message']);
    } catch (e) {
      print("Error encountered: ${e}");
    }
    return false;
  }

  Future<bool> deleteItem(int id, String serviceName) async {
    try {
      print("Adding item");
      String url = "$BASE_URL$serviceName/delete/$id";

      final response = await delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      dynamic respObj = jsonDecode(response.body);
      if (respObj['code'] == '000') {
        return true;
      }
      throw Exception(respObj['message']);
    } catch (e) {
      print("Error encountered: $e");
    }
    return false;
  }
}
