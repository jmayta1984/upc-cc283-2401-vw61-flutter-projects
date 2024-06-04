import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:turismo_app/models/package.dart';

class PackageService {
  final baseUrl =
      "https://dev.formandocodigo.com/ServicioTour/productossitiotipo.php?sitio=";

  Future<List<Package>> getByPlaceAndType(String place, String type) async {
    http.Response response =
        await http.get(Uri.parse("$baseUrl$place&tipo=$type"));

    if (response.statusCode == HttpStatus.ok) {
      List maps = json.decode(response.body);
      return maps.map((map) => Package.fromJson(map)).toList();
    }
    return [];
  }
}
