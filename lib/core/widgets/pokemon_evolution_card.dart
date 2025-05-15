import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';

class PokemonEvolutionCard extends StatelessWidget {
  const PokemonEvolutionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Colors.red,
              borderRadius: BorderRadius.circular(71),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CachedNetworkImage(
                  imageUrl:
                      'https://assets.pokemon.com/assets/cms2/img/pokedex/full/001.png'),
            ),
          ),
          Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bulbasaur',
                style: AppTextStyles.baseText,
              ),
              Gap(8),
              Row(
                children: [
                  Container(
                    width: 68,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(Icons.label, size: 12),
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
