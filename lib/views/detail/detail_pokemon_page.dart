import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/core/widgets/attribut_display.dart';
import 'package:pokedex_app/core/widgets/custom_chip.dart';
import 'package:pokedex_app/core/widgets/pokemon_evolution_card.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/tab_provider.dart';
import 'package:provider/provider.dart';

class DetailPokemonPage extends StatefulWidget {
  const DetailPokemonPage({super.key, required this.pokemon});
  final PokemonModel pokemon;

  @override
  State<DetailPokemonPage> createState() => _DetailPokemonPageState();
}

class _DetailPokemonPageState extends State<DetailPokemonPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonDetailProvider>(context, listen: false)
          .fetchByIds(widget.pokemon.evolutions);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainType = PokemonType.values.firstWhere(
      (e) =>
          e.name.toLowerCase() == widget.pokemon.typeofpokemon[0].toLowerCase(),
      orElse: () => PokemonType.normal,
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            pinned: false,
            leading: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.white,
            ),
            actions: [
              Consumer<PokemonFavoriteProvider>(
                builder: (context, value, child) => InkWell(
                  onTap: () {
                    value.toggleFavorite(widget.pokemon.id);

                    if (value.isFavorite(widget.pokemon.id)) {
                      context.read<TabProvider>().setIndex(1);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: SvgPicture.asset(
                      value.isFavorite(widget.pokemon.id)
                          ? 'assets/icons/selected_favorite_2.svg'
                          : 'assets/icons/unselected_favorite_2.svg',
                    ),
                  ),
                ),
              )
            ],
            backgroundColor: mainType.color,
            surfaceTintColor: mainType.color,
            foregroundColor: mainType.color,
            elevation: 0,
          ),
          SliverToBoxAdapter(
              child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                Positioned(
                  top: -277,
                  left: -73,
                  right: -73,
                  child: Container(
                    width: 500,
                    height: 500,
                    decoration: BoxDecoration(
                      color: mainType.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 130,
                  right: 130,
                  child: SizedBox(
                    width: 30,
                    child: Hero(
                      tag: 'pokemon-image-${widget.pokemon.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.pokemon.imageUrl,
                        fit: BoxFit.fitWidth,
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
              ],
            ),
          )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.pokemon.name, style: AppTextStyles.headline1),
                  Gap(36),
                  Wrap(
                    spacing: 4.0,
                    runSpacing: 4.0,
                    children: widget.pokemon.typeofpokemon
                        .asMap()
                        .entries
                        .map((entry) {
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
                  ),
                  Gap(36),
                  Text(
                    widget.pokemon.xdescription,
                    style: AppTextStyles.bodyLarge,
                  ),
                  Gap(24),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Gap(16),
                  _buildPokemonStat(),
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
                    itemCount: widget.pokemon.weaknesses.length,
                    itemBuilder: (context, index) {
                      final pokemonElement = widget.pokemon.weaknesses[index];

                      return CustomChipContainer(
                        element: pokemonElement,
                        type: PokemonType.values.firstWhere(
                          (e) =>
                              e.name.toLowerCase() ==
                              pokemonElement.toLowerCase(),
                          orElse: () => PokemonType.normal,
                        ),
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
          ),
        ],
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
              child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => PokemonEvolutionCard(
                        pokemon: value.pokemon[index],
                      ),
                  separatorBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SvgPicture.asset('assets/icons/arrow_down.svg'),
                      ),
                  itemCount: value.pokemon.length),
            ),
    );
  }

  Column _buildPokemonStat() {
    return Column(children: [
      Row(
        children: [
          Flexible(
            child: AttributDisplay(
              title: 'WEIGHT',
              data: widget.pokemon.weight,
              icon: Icons.height,
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'HEIGHT',
              data: widget.pokemon.height,
              icon: Icons.height,
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
              data: widget.pokemon.category,
              icon: Icons.height,
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'ABILITY',
              data: widget.pokemon.abilities[0],
              icon: Icons.height,
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
          LinearProgressIndicator(
            value: 0.5,
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              children: [
                Icon(Icons.female_outlined),
                Text(widget.pokemon.femalePercentage ?? '-'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.male_outlined),
                Text(widget.pokemon.malePercentage ?? '-'),
              ],
            )
          ]),
        ],
      ),
    ]);
  }
}
