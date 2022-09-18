import 'dart:convert';

import 'package:edar_app/constants/strings.dart';
import 'package:http/http.dart';

class NetworkService {
  Future<List<dynamic>> fetchAll(String serviceName) async {
    try {
      final response = await get(Uri.parse("$BASE_URL$serviceName"));
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> addItem(
    Map<String, dynamic> addObj,
    String serviceName,
  ) async {
    try {
      // addObj = {"categoryCode": "asd", "categoryName": "asdasd"};
      print("Calling :${serviceName}");
      print("To String: " + jsonEncode(addObj));
      final response = await post(Uri.parse("$BASE_URL$serviceName"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(addObj));
      //TODO Handle other response code
      // return jsonDecode(response.body);
      return true;
    } catch (e) {
      print("Error encountered: ${e}");
      return false;
    }
  }

  Future<bool> udpateItem(
      Map<String, dynamic> categoryObj, int id, String serviceName) async {
    try {
      print("Updating item");
      await patch(Uri.parse("$BASE_URL$serviceName/$id"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(categoryObj));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteItem(int id, String serviceName) async {
    try {
      await delete(Uri.parse("$BASE_URL$serviceName/$id"));
      return true;
      //TODO: Handle error when deleting category with dependent products
    } catch (e) {
      print(e);
      return false;
    }
  }
}
