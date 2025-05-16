import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class PokemonFavoriteProvider with ChangeNotifier {
  final Box<List> _favoriteBox = Hive.box<List>('favorites');

  List<String> _favorites = [];

  PokemonFavoriteProvider() {
    _loadFavorites();
  }

  void _loadFavorites() {
    _favorites = List<String>.from(_favoriteBox.get('pokemon_ids') ?? []);
  }

  List<String> get favorites => _favorites;

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }

    _favoriteBox.put('pokemon_ids', _favorites);
    notifyListeners();
  }
}
