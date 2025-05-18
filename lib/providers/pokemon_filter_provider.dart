import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonFilterProvider with ChangeNotifier {
  String _selectedType = 'All';
  bool _isLoading = false;
  List<PokemonModel> _allPokemon = [];
  List<PokemonModel> _filteredPokemon = [];
  final List<PokemonModel> _visiblePokemon = [];

  int _currentPage = 0;
  final int _pageSize = 20;

  String get selectedType => _selectedType;
  bool get isLoading => _isLoading;
  List<PokemonModel> get visibleFilteredPokemon => _visiblePokemon;

  void updateAllPokemon(List<PokemonModel> all) {
    _allPokemon = all;
    _filteredPokemon = all;
  }

  void setType(String type) {
    if (_selectedType != type) {
      _selectedType = type;
      notifyListeners();
    }
  }

  bool isTypeSelected(String type) => _selectedType == type;

  Future<void> filterByType(String type) async {
    _isLoading = true;
    _selectedType = type;
    _currentPage = 0;
    _visiblePokemon.clear();
    notifyListeners();

    try {
      if (type == 'All') {
        _filteredPokemon = _allPokemon;
      } else {
        _filteredPokemon = _allPokemon
            .where((poke) => poke.typeofpokemon.contains(type))
            .toList();
      }

      debugPrint('Filtered Pokemon: $_filteredPokemon');

      fetchNextPage();
    } catch (e, stackTrace) {
      debugPrint('filterByType Error: $e\n$stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchNextPage() {
    if (_filteredPokemon.isEmpty) return;

    final startIndex = _currentPage * _pageSize;
    final endIndex = (_currentPage + 1) * _pageSize;
    if (startIndex >= _filteredPokemon.length) return;

    final nextPage = _filteredPokemon.sublist(
      startIndex,
      endIndex > _filteredPokemon.length ? _filteredPokemon.length : endIndex,
    );

    _visiblePokemon.addAll(nextPage);

    _currentPage++;
    notifyListeners();
  }

  void reset() {
    _selectedType = 'All';
    _filteredPokemon = _allPokemon;
    _visiblePokemon.clear();
    _currentPage = 0;
    fetchNextPage();
    notifyListeners();
  }
}
