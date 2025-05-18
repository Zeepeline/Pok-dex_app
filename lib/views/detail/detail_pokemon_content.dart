import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/core/utils/parse_percantage.dart';
import 'package:pokedex_app/core/widgets/attribut_display.dart';
import 'package:pokedex_app/core/widgets/custom_chip.dart';
import 'package:pokedex_app/core/widgets/pokemon_evolution_card.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:provider/provider.dart';

class DetailPokemonContent extends StatelessWidget {
  const DetailPokemonContent(
      {super.key, required this.pokemon, required this.onOtherPokemonTap});

  final PokemonModel pokemon;
  final VoidCallback onOtherPokemonTap;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16),
            Text(pokemon.name, style: AppTextStyles.headline1),
            Gap(36),
            Wrap(
              spacing: 4.0,
              runSpacing: 4.0,
              children: pokemon.typeofpokemon.asMap().entries.map((entry) {
                final pokemonElement = entry.value;

                return CustomElementChipContainer(
                  element: pokemonElement,
                  type: pokemonElement.asPokemonType,
                );
              }).toList(),
            ),
            Gap(36),
            Text(
              pokemon.xdescription,
              style: AppTextStyles.bodyLarge,
            ),
            Gap(24),
            Divider(
              thickness: 1,
              color: Colors.black.withValues(alpha: 0.1),
            ),
            Gap(16),
            _buildPokemonStat(pokemon),
            Gap(32),
            Text(
              'Weakness',
              style: AppTextStyles.subtitle,
            ),
            Gap(8),
            MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pokemon.weaknesses.length,
              itemBuilder: (context, index) {
                final pokemonElement = pokemon.weaknesses[index];

                return CustomElementChipContainer(
                  element: pokemonElement,
                  type: pokemonElement.asPokemonType,
                );
              },
            ),
            Gap(24),
            Text(
              'Evolution',
              style: AppTextStyles.subtitle,
            ),
            Gap(16),
            _buildPokemonEvolution(),
            Gap(16),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonEvolution() {
    return Consumer<PokemonDetailProvider>(
      builder: (context, value, child) => value.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Color(0xFFE6E6E6),
                  width: 1,
                ),
              ),
              child: value.pokemon.isEmpty
                  ? Center(
                      child: Column(
                      children: [
                        Image.asset('assets/images/game.png', width: 100),
                        Gap(16),
                        Text(
                          ''' I'm the strongest, I don't need evolutions ''',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ))
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context
                                    .read<PokemonDetailProvider>()
                                    .setSelectedPokemon(value.pokemon[index]);
                              });

                              onOtherPokemonTap();
                            },
                            child: PokemonEvolutionCard(
                              pokemon: value.pokemon[index],
                            ),
                          ),
                      separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child:
                                SvgPicture.asset('assets/icons/arrow_down.svg'),
                          ),
                      itemCount: value.pokemon.length),
            ),
    );
  }

  Column _buildPokemonStat(PokemonModel pokemon) {
    return Column(children: [
      Row(
        children: [
          Flexible(
            child: AttributDisplay(
              title: 'WEIGHT',
              data: pokemon.weight,
              iconPath: 'assets/icons/weight.svg',
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'HEIGHT',
              data: pokemon.height,
              iconPath: 'assets/icons/height.svg',
            ),
          ),
        ],
      ),
      Gap(24),
      Row(
        children: [
          Flexible(
            child: AttributDisplay(
              title: 'CATEGORY',
              data: pokemon.category,
              iconPath: 'assets/icons/category.svg',
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'ABILITY',
              data: pokemon.abilities[0],
              iconPath: 'assets/icons/ability.svg',
            ),
          ),
        ],
      ),
      Gap(24),
      Column(
        children: [
          Text(
            'GENDER',
          ),
          Gap(8),
          Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Color(0xFFFF7596),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: LinearProgressIndicator(
              value: parsePercentage(pokemon.malePercentage ?? '0'),
              minHeight: 8,
              backgroundColor: Colors.transparent,
              color: Color(0xFF2551C3),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
          ),
          Gap(8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Icon(Icons.male_outlined),
                Text(
                  pokemon.malePercentage ?? '-',
                  style: AppTextStyles.label,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.female_outlined),
                Text(
                  pokemon.femalePercentage ?? '-',
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ]),
        ],
      ),
    ]);
  }
}
