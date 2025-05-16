import 'package:pokedex_app/data/models/pokemon_model.dart';

abstract class PokemonLocalDatasources {
  Future<List<PokemonModel>> fetchPokemonList();
}
