import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/helpers/toast_helpers.dart';
import 'package:pokedex_app/core/widgets/pokemon_card.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class FavoritePokemonPage extends StatelessWidget {
  const FavoritePokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Pokémon'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Consumer2<PokemonProvider, PokemonFavoriteProvider>(
          builder: (context, pokemonProvider, favoriteProvider, _) {
            final allPokemon = pokemonProvider.allPokemon;
            final favoriteIds = favoriteProvider.favorites;

            final favoritePokemon =
                allPokemon.where((p) => favoriteIds.contains(p.id)).toList();

            if (favoritePokemon.isEmpty) {
              return const Center(child: Text('No favorite Pokémon yet.'));
            }

            return ListView.separated(
              itemCount: favoritePokemon.length,
              separatorBuilder: (context, index) => const Gap(16),
              itemBuilder: (context, index) {
                final pokemon = favoritePokemon[index];
                return PokemonCard(
                  pokemon: pokemon,
                  isFavorite: true,
                  onFavoriteTap: () {
                    favoriteProvider.toggleFavorite(pokemon.id);

                    failToast(context, 'Removed from favorites',
                        '${pokemon.name} removed from favorites!');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
