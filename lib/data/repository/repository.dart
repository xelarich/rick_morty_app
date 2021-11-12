import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rick_morty_app/data/model/character.dart';

Future<Character> getCharacter(int id) async {
  final response = await http.get(Uri.parse('https://rickandmortyapi.com/api/character/$id'));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return  Character.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load character');
  }
}