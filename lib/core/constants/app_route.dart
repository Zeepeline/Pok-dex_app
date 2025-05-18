import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/core/widgets/slide_from_bottom_page.dart';
import 'package:pokedex_app/views/detail/detail_pokemon_page.dart';
import 'package:pokedex_app/views/navigation/main_navigation.dart';

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
          MaterialPage(child: MainNavigation()),
          if (appState.selectedPokemon != null)
            SlideFromBottomPage(
              key: ValueKey(appState.selectedPokemon!.id),
              child: DetailPokemonPage(pokemon: appState.selectedPokemon!),
            ),
        ],
        onDidRemovePage: (page) {
          appState.goToHome();
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
