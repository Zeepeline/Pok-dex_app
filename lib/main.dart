import 'package:flutter/material.dart';
import 'package:pokedex_app/app.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/data/datasources/pokemon_remote_datasources.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:pokedex_app/providers/pokemon_search_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final remoteDatasource = PokemonRemoteDatasourcesImpl();
  final repository = PokemonRepositoryImpl(remoteDatasource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonProvider(repository)),
        ChangeNotifierProxyProvider<PokemonProvider, PokemonDetailProvider>(
          create: (_) => PokemonDetailProvider(),
          update: (_, pokemonProvider, detailProvider) {
            detailProvider!.updateAllPokemon(pokemonProvider.pokemonList);
            return detailProvider;
          },
        ),
        ChangeNotifierProxyProvider<PokemonProvider, PokemonSearchProvider>(
          create: (_) => PokemonSearchProvider(),
          update: (_, pokemonProvider, searchProvider) {
            searchProvider!.updateAllPokemon(pokemonProvider.allPokemon);
            return searchProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MyApp(),
    ),
  );
}
