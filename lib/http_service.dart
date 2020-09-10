import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class HttpService {

  Future<UserModel> userGet() async {
    final cevap = await http.get("https://reqres.in/api/users/");

    if (cevap.statusCode == 200) {
      return UserModel.fromJson(json.decode(cevap.body));
    } else {
      throw Exception("Hata oluştu ! ${cevap.statusCode}");
    }
  }

}