import 'package:flutter/foundation.dart';
import 'package:pokedex_app/core/enums/state_enum.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonRepository pokemonRepository;

  PokemonProvider(this.pokemonRepository);

  List<PokemonModel> _allPokemon = [];
  final List<PokemonModel> _visiblePokemon = [];
  int _currentPage = 0;
  final int _pageSize = 20;

  List<PokemonModel> get pokemonList => _visiblePokemon;
  List<PokemonModel> get allPokemon => _allPokemon;

  PokemonLoadState _state = PokemonLoadState.initial;
  PokemonLoadState get state => _state;

  bool get isLoading => _state == PokemonLoadState.loading;
  bool get isLoadingMore => _state == PokemonLoadState.loadingMore;

  Future<void> initData() async {
    if (_allPokemon.isNotEmpty) return;

    _state = PokemonLoadState.loading;
    notifyListeners();

    try {
      _allPokemon = await pokemonRepository.fetchPokemonList();
      _visiblePokemon.clear();
      _currentPage = 0;

      await fetchNextPokemonPage();
    } catch (e) {
      debugPrint('Error fetching Pokémon: $e');
      _state = PokemonLoadState.error;
      notifyListeners();
    }
  }

  Future<void> fetchNextPokemonPage() async {
    if (_state == PokemonLoadState.loadingMore || _allPokemon.isEmpty) return;

    final startIndex = _currentPage * _pageSize;
    final endIndex = (_currentPage + 1) * _pageSize;

    if (startIndex >= _allPokemon.length) return;
    if (_state != PokemonLoadState.loading) {
      _state = PokemonLoadState.loadingMore;
    }
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final nextPage = _allPokemon.sublist(
      startIndex,
      endIndex > _allPokemon.length ? _allPokemon.length : endIndex,
    );

    _visiblePokemon.addAll(nextPage);

    _currentPage++;
    _state = PokemonLoadState.loaded;
    notifyListeners();
  }
}
