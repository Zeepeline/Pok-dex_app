import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
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
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          padding: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 1),
                blurRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: const Text('Favorite', style: AppTextStyles.subtitle),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(16),
              Consumer2<PokemonProvider, PokemonFavoriteProvider>(
                builder: (context, pokemonProvider, favoriteProvider, _) {
                  final allPokemon = pokemonProvider.allPokemon;
                  final favoriteIds = favoriteProvider.favorites;

                  final favoritePokemon = allPokemon
                      .where((p) => favoriteIds.contains(p.id))
                      .toList();

                  if (favoritePokemon.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/camera.png', width: 100),
                          const Gap(16),
                          Text(
                              """ You haven't added any Pokémon to favorites yet """,
                              style: AppTextStyles.bodyLarge),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoritePokemon.length,
                    separatorBuilder: (context, index) => const Gap(16),
                    itemBuilder: (context, index) {
                      final pokemon = favoritePokemon[index];
                      return InkWell(
                        onTap: () {
                          context.read<AppState>().selectPokemon(pokemon);
                        },
                        child: PokemonCard(
                          pokemon: pokemon,
                          isFavorite: true,
                          onFavoriteTap: () {
                            favoriteProvider.toggleFavorite(pokemon.id);
                            failToast(context, 'Removed from favorites',
                                '${pokemon.name} removed from favorites!');
                          },
                        ),
                      );
                    },
                  );
                },
              ),
              Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
