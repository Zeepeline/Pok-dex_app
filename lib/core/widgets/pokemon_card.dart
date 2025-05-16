import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/core/widgets/custom_chip.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onFavoriteTap,
  });
  final PokemonModel pokemon;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final mainType = PokemonType.values.firstWhere(
      (e) => e.name.toLowerCase() == pokemon.typeofpokemon[0].toLowerCase(),
      orElse: () => PokemonType.normal,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 32, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name,
                    style: AppTextStyles.headingMedium,
                  ),
                  Gap(8),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children:
                        pokemon.typeofpokemon.asMap().entries.map((entry) {
                      final pokemonElement = entry.value;

                      return CustomChipContainer(
                        element: pokemonElement,
                        type: PokemonType.values.firstWhere(
                          (e) =>
                              e.name.toLowerCase() ==
                              pokemonElement.toLowerCase(),
                          orElse: () => PokemonType.normal,
                        ),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: mainType.color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Hero(
                      tag: 'pokemon-image-${pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                        onTap: onFavoriteTap,
                        child: SvgPicture.asset(isFavorite
                            ? 'assets/icons/selected_love.svg'
                            : 'assets/icons/love_disable.svg')))
              ],
            ),
          )
        ],
      ),
    );
  }
}
