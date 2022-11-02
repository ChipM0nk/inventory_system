// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/io_client.dart';

import 'package:edar_app/constants/constants.dart';
import 'package:edar_app/local_storage.dart';
import 'package:http/http.dart';
import 'package:universal_io/io.dart';

class NetworkService {
  Future<dynamic> authenticate(Map<String, dynamic> userObj) async {
    String url = "$BASE_URL/authenticate/";
    // ByteData data = await rootBundle.load('assets/keystore.p12');
    // SecurityContext context = SecurityContext.defaultContext;
    // context.setTrustedCertificatesBytes(data.buffer.asUint8List(),
    //     password: "password");
    // final httpClient = HttpClient(context: context);
    // final httpClient = BrowserHttpClient();

    // // httpClient
    // //   ..badCertificateCallback =
    // //       (X509Certificate cert, String host, int port) => true;
    // // final client = IOClient(httpClient);

    // final request = await httpClient.postUrl(Uri.parse(url));
    // request.headers
    //     .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    // request.write(jsonEncode(userObj));
    // print("invoke request");
    // final response = await request.close();
    // print("response : ${response.toString()}");
    // dynamic respObj = jsonDecode(await response.transform(utf8.decoder).join());
    final response = await post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': 'true'
        },
        body: jsonEncode(userObj));
    dynamic respObj = jsonDecode(response.body);
    print("Decode Sucess!");
    if (respObj['code'] == '000') {
      dynamic respBody = respObj['body'];
      print("Response Body extracted!");
      return respBody;
    }

    throw Exception(respObj['message']);
  }

  Future<List<dynamic>> fetchWithParam(
      String serviceName, Map<String, dynamic> paramObj) async {
    try {
      print("Parameter :${json.encode(paramObj)}");
      String url = "$BASE_URL$serviceName/all/param";

      final response = await post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${await LocalStorage.read("jwt")}",
          },
          body: jsonEncode(paramObj));
      dynamic respObj = jsonDecode(response.body);
      // print(json.encode(respObj));
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
      // print(json.encode(respObj));
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
