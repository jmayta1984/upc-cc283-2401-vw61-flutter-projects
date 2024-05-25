import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rick_morty_app/models/character.dart';

class CharacterService {
  final String baseUrl = "https://rickandmortyapi.com/api/character";

  Future<List> getAll(int page) async {
    final http.Response response = await http.get(Uri.parse("$baseUrl?page=$page"));

    if (response.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(response.body);
      final List maps = jsonResponse["results"];

      return maps.map((map)=> Character.fromJson(map)).toList();
    }
    return [];
  }
  
}