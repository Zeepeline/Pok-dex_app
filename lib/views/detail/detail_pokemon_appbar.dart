import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/tab_provider.dart';
import 'package:provider/provider.dart';

class PokemonDetailAppBar extends StatelessWidget {
  final PokemonModel pokemon;
  final VoidCallback onBack;

  const PokemonDetailAppBar({
    super.key,
    required this.pokemon,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final pokemonName =
        pokemon.name.replaceAll(RegExp(r'[^\w\s]'), '').toLowerCase();
    return SliverAppBar(
      floating: false,
      snap: false,
      pinned: false,
      leading: InkWell(
        onTap: () {
          context.read<PokemonDetailProvider>().setSelectedPokemon(null);
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
        ),
      ),
      actions: [
        Consumer<PokemonFavoriteProvider>(
          builder: (context, value, child) => InkWell(
            onTap: () {
              value.toggleFavorite(pokemon.id);

              if (value.isFavorite(pokemon.id)) {
                context.read<TabProvider>().setIndex(1);
                Navigator.of(context).pop();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset(
                value.isFavorite(pokemon.id)
                    ? 'assets/icons/selected_favorite_2.svg'
                    : 'assets/icons/unselected_favorite_2.svg',
              ),
            ),
          ),
        )
      ],
      backgroundColor: Colors.white,
      surfaceTintColor: pokemon.typeofpokemon[0].asPokemonType.color,
      foregroundColor: pokemon.typeofpokemon[0].asPokemonType.color,
      elevation: 0,
      expandedHeight: 350,
      flexibleSpace: FlexibleSpaceBar(
        background: SizedBox(
          height: 350,
          child: Stack(
            children: [
              Positioned(
                top: -250,
                left: -73,
                right: -73,
                child: Container(
                  width: 500,
                  height: 500,
                  alignment: const Alignment(0.0, 0.7),
                  margin: const EdgeInsets.only(top: 36),
                  decoration: BoxDecoration(
                    color: pokemon.typeofpokemon[0].asPokemonType.color,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    pokemon.typeofpokemon[0].asPokemonType.iconPath,
                    width: 150,
                    colorFilter: ColorFilter.mode(
                        Colors.white.withAlpha(40), BlendMode.srcIn),
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
                left: 130,
                right: 130,
                child: SizedBox(
                  child: Hero(
                      tag: 'pokemon-image-${pokemon.id}',
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Transform.scale(
                          scale: 2,
                          alignment: Alignment.bottomCenter,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://play.pokemonshowdown.com/sprites/ani/$pokemonName.gif',
                            filterQuality: FilterQuality.high,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.error, color: Colors.white)),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
