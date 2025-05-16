import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class AppState extends ChangeNotifier {
  PokemonModel? selectedPokemon;

  void selectPokemon(PokemonModel pokemon) {
    selectedPokemon = pokemon;
    notifyListeners();
  }

  void goToHome() {
    selectedPokemon = null;
    notifyListeners();
  }
}
