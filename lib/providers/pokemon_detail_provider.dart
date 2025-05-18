import 'package:flutter/material.dart';
import 'package:pokedex_app/core/enums/state_enum.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonDetailProvider extends ChangeNotifier {
  List<PokemonModel> _pokemon = [];

  PokemonModel? _selectedPokemon;
  PokemonLoadState _state = PokemonLoadState.initial;

  PokemonLoadState get state => _state;
  List<PokemonModel> _allPokemon = [];
  List<PokemonModel> get pokemon => _pokemon;
  PokemonModel? get selectedPokemon => _selectedPokemon;
  bool get isLoading => _state == PokemonLoadState.loading;

  void updateAllPokemon(List<PokemonModel> all) {
    _allPokemon = all;
  }

  Future<void> fetchByIds(List<String> ids) async {
    _state = PokemonLoadState.loading;
    notifyListeners();

    try {
      _pokemon = _allPokemon.where((poke) => ids.contains(poke.id)).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }

    _state = PokemonLoadState.loaded;
    notifyListeners();
  }

  void clear() {
    _pokemon = [];
    notifyListeners();
  }

  void setSelectedPokemon(PokemonModel? pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();

    if (pokemon != null) {
      fetchByIds(pokemon.evolutions);
    }
  }
}
