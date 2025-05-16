import 'package:flutter/foundation.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonRepository pokemonRepository;

  PokemonProvider(this.pokemonRepository);

  List<PokemonModel> _allPokemon = [];
  final List<PokemonModel> _visiblePokemon = [];
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _isLoading = false;

  List<PokemonModel> get pokemonList => _visiblePokemon;
  bool get isLoading => _isLoading;

  Future<void> initData() async {
    if (_allPokemon.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allPokemon = await pokemonRepository.fetchPokemonList();

      _isLoading = false;
      notifyListeners();

      fetchNextPokemonPage();
    } catch (e) {
      debugPrint('Error fetching Pokémon: $e');

      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchNextPokemonPage() {
    if (_isLoading || _allPokemon.isEmpty) return;

    final startIndex = _currentPage * _pageSize;
    final endIndex = (_currentPage + 1) * _pageSize;

    if (startIndex >= _allPokemon.length) return;

    final nextPage = _allPokemon.sublist(
      startIndex,
      endIndex > _allPokemon.length ? _allPokemon.length : endIndex,
    );

    _visiblePokemon.addAll(nextPage);
    print('test ${_visiblePokemon.length}');

    _currentPage++;
    notifyListeners();
  }
}
