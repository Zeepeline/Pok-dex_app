import 'package:pokedex_app/data/datasources/pokemon_remote_datasources.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

abstract class PokemonRepository {
  Future<List<PokemonModel>> fetchPokemonList();
}

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDatasources pokemonRemoteDatasources;

  PokemonRepositoryImpl(this.pokemonRemoteDatasources);
  @override
  Future<List<PokemonModel>> fetchPokemonList() async {
    return pokemonRemoteDatasources.fetchPokemonList();
  }
}
