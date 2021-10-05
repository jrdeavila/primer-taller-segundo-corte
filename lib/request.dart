import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> storeResponse(Map<String, dynamic> jsonData) async {
  if (!jsonData.containsKey('response')) {
    Future<SharedPreferences> _localuser = SharedPreferences.getInstance();
    final SharedPreferences localuser = await _localuser;
    localuser.setString('nombres', jsonData['nombres']);
    localuser.setString('email', jsonData['email']);
    localuser.setString('color', jsonData['color']);
    localuser.setString('estado', jsonData['estado']);
    localuser.setString('acceso', jsonData['acceso']);
    localuser.setString('apellidos', jsonData['apellidos']);
    localuser.setString('telefono', jsonData['telefono']);
    return "";
  } else {
    return jsonData["response"];
  }
}

Future<String> addUser(
    names, lastNames, password, email, username, phone) async {
  var url = Uri.parse('https://school-academic.000webhostapp.com/api/register');
  var parameters = <String, String>{
    "nombres": names,
    "apellidos": lastNames,
    "email": email,
    "password": password,
    "telefono": phone,
    "username": username
  };
  var response = await http.post(url, body: jsonEncode(parameters));
  var jsonData = json.decode(response.body);
  return storeResponse(jsonData);
}

Future<String> entry(username, password) async {
  var url = Uri.parse('https://school-academic.000webhostapp.com/api/auth');
  var response = await http.post(url,
      body: jsonEncode(
          <String, String>{'email': username, 'password': password}));
  var jsonData = json.decode(response.body);
  return await storeResponse(jsonData);
}
