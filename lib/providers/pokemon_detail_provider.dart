import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonDetailProvider extends ChangeNotifier {
  List<PokemonModel> _pokemon = [];
  bool _isLoading = false;
  PokemonModel? _selectedPokemon;
  bool get isLoading => _isLoading;

  List<PokemonModel> _allPokemon = [];
  List<PokemonModel> get pokemon => _pokemon;
  PokemonModel? get selectedPokemon => _selectedPokemon;

  void updateAllPokemon(List<PokemonModel> all) {
    _allPokemon = all;
  }

  Future<void> fetchByIds(List<String> ids) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pokemon = _allPokemon.where((poke) => ids.contains(poke.id)).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }

    _isLoading = false;
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
