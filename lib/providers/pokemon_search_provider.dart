import 'dart:developer';

import 'package:flutter/foundation.dart';
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

  Future<void> fetchByNamesOrIds(String query) async {
    _isLoading = true;
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

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchByPokedexNumber(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final query = id.toLowerCase().replaceAll('#', '').trim();

      _searchResult = _allPokemon.where((poke) {
        final pokeIdNormalized =
            poke.id.toLowerCase().replaceAll('#', '').trim();
        return pokeIdNormalized.contains(query);
      }).toList();

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

// Fungsi filter yang akan dijalankan di isolate terpisah
List<PokemonModel> searchInBackground(Map<String, dynamic> params) {
  final List<PokemonModel> allPokemon = params['allPokemon'];
  final String query = params['query'].toLowerCase().trim();

  final isNumberSearch = RegExp(r'^#?\d+$').hasMatch(query);

  if (isNumberSearch) {
    final normalizedQuery = query.replaceAll('#', '');
    return allPokemon.where((poke) {
      final pokeIdNormalized = poke.id.toLowerCase().replaceAll('#', '').trim();
      return pokeIdNormalized.contains(normalizedQuery);
    }).toList();
  } else {
    return allPokemon.where((poke) {
      return poke.name.toLowerCase().contains(query);
    }).toList();
  }
}
