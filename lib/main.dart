import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokedex_app/app.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/data/datasources/pokemon_remote_datasources.dart';
import 'package:pokedex_app/data/repositories/pokemon_repository.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:pokedex_app/providers/pokemon_search_provider.dart';
import 'package:pokedex_app/providers/tab_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox<List>('favorites');

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
        ChangeNotifierProvider(create: (_) => PokemonFavoriteProvider()),
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => TabProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
