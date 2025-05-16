import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';

class PokemonEvolutionCard extends StatelessWidget {
  const PokemonEvolutionCard({
    super.key,
    required this.pokemon,
  });

  final PokemonModel pokemon;

  @override
  Widget build(BuildContext context) {
    final mainType = PokemonType.values.firstWhere(
      (e) => e.name.toLowerCase() == pokemon.typeofpokemon[0].toLowerCase(),
      orElse: () => PokemonType.normal,
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          color: Color(0xFFE6E6E6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 95,
            height: 74,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: mainType.color,
              borderRadius: BorderRadius.circular(71),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CachedNetworkImage(imageUrl: pokemon.imageUrl),
            ),
          ),
          Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pokemon.name,
                style: AppTextStyles.baseText,
              ),
              Gap(8),
              Row(
                children: [
                  Container(
                    width: 68,
                    decoration: BoxDecoration(
                        color: mainType.color,
                        borderRadius: BorderRadius.circular(20)),
                    child: SvgPicture.asset(
                      mainType.iconPath,
                      width: 10,
                      height: 10,
                      colorFilter:
                          ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
