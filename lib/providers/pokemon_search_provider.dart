import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_app/core/enums/state_enum.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonSearchProvider with ChangeNotifier {
  List<PokemonModel> _searchResult = [];
  String _searchText = '';
  PokemonLoadState _state = PokemonLoadState.initial;

  List<PokemonModel> get searchResult => _searchResult;
  String get searchText => _searchText;
  PokemonLoadState get state => _state;
  bool get isLoading => _state == PokemonLoadState.loading;

  List<PokemonModel> _allPokemon = [];

  void updateAllPokemon(List<PokemonModel> all) {
    _allPokemon = all;
  }

  Future<void> fetchByNamesOrIds(String query) async {
    _state = PokemonLoadState.loading;
    notifyListeners();

    try {
      _searchText = query;
      final search = query.toLowerCase().trim();

      // Cek apakah input adalah nomor pokedex (angka atau #di depan)
      final isNumberSearch = RegExp(r'^#?\d+$').hasMatch(search);

      if (isNumberSearch) {
        // Hilangkan '#' jika ada
        final normalizedQuery = search.replaceAll('#', '');
        final paddedQuery = '#${normalizedQuery.padLeft(3, '0')}';

        _searchResult = _allPokemon.where((poke) {
          final pokeIdNormalized = poke.id.toLowerCase().trim();
          return pokeIdNormalized.contains(paddedQuery);
        }).toList();
      } else {
        // Search berdasarkan nama (case insensitive)
        _searchResult = _allPokemon.where((poke) {
          return poke.name.toLowerCase().contains(search);
        }).toList();
      }

      log(_searchResult.toString());
    } catch (e) {
      debugPrint('Error: $e');
    }

    _state = PokemonLoadState.loaded;
    notifyListeners();
  }

  void clear() {
    _searchResult = [];
    notifyListeners();
  }
}
