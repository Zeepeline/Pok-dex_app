import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonSearchProvider with ChangeNotifier {
  bool _isLoading = false;
  List<PokemonModel> _searchResult = [];
  String _searchText = '';

  List<PokemonModel> get searchResult => _searchResult;
  String get searchText => _searchText;
  bool get isLoading => _isLoading;

  List<PokemonModel> _allPokemon = [];

  void updateAllPokemon(List<PokemonModel> all) {
    _allPokemon = all;
  }

  Future<void> fetchByNames(String names) async {
    _isLoading = true;
    notifyListeners();

    try {
      _searchText = names;
      _searchResult = _allPokemon
          .where(
            (poke) => poke.name.toLowerCase().contains(names.toLowerCase()),
          )
          .toList();

      log(_searchResult.toString());
    } catch (e) {
      debugPrint('Error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _searchResult = [];
    notifyListeners();
  }
}
