import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/views/detail/detail_pokemon_page.dart';
import 'package:pokedex_app/views/home/home_page.dart';

class MyRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  final AppState appState;

  MyRouterDelegate(this.appState) {
    appState.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(child: HomePage()),
          if (appState.selectedPokemon != null)
            MaterialPage(
                child: DetailPokemonPage(pokemon: appState.selectedPokemon!)),
        ],
        onDidRemovePage: (page) {
          appState.goToHome();
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
