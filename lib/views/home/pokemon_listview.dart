import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/helpers/toast_helpers.dart';
import 'package:pokedex_app/core/widgets/pokemon_card.dart';
import 'package:pokedex_app/core/widgets/pokemon_card_shimmer.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:provider/provider.dart';

class PokemonListView extends StatelessWidget {
  final List<PokemonModel> pokemonList;
  final bool isLoadingMore;

  const PokemonListView(
      {required this.pokemonList, required this.isLoadingMore, super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = context.watch<PokemonFavoriteProvider>();

    if (pokemonList.isEmpty) return _buildEmptyState();

    return ListView.separated(
      shrinkWrap: true,
      cacheExtent: 500,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pokemonList.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const Gap(16),
      itemBuilder: (context, index) {
        if (index == pokemonList.length) {
          return const PokemonCardShimmer();
        }
        final pokemon = pokemonList[index];
        final isFav = favoriteProvider.isFavorite(pokemon.id);
        return InkWell(
          onTap: () => context.read<AppState>().selectPokemon(pokemon),
          child: PokemonCard(
            pokemon: pokemon,
            isFavorite: isFav,
            onFavoriteTap: () {
              favoriteProvider.toggleFavorite(pokemon.id);
              isFav
                  ? failToast(context, 'Removed', '${pokemon.name} removed!')
                  : successToast(context, 'Added', '${pokemon.name} added!');
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            SvgPicture.network(
                'https://veekun.com/dex/media/pokemon/dream-world/201-question.svg'),
            const Gap(16),
            Text(
              'No Pokemon found',
              style: AppTextStyles.subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
