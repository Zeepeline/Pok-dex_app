import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/models/pokemon_model.dart';

abstract class PokemonRemoteDatasources {
  Future<List<PokemonModel>> fetchPokemonList();
}

class PokemonRemoteDatasourcesImpl implements PokemonRemoteDatasources {
  @override
  Future<List<PokemonModel>> fetchPokemonList() async {
    final response = await http.get(Uri.parse(
        "https://gist.githubusercontent.com/hungps/0bfdd96d3ab9ee20c2e572e47c6834c7/raw/pokemons.json"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      log(data.toString());
      return data.map((json) => PokemonModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load Pokémons");
    }
  }
}
