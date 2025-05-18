import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/core/utils/parse_percantage.dart';
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
  late PokemonModel newDataPokemon;
  final ScrollController _scrollController = ScrollController();
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
    newDataPokemon = context.watch<PokemonDetailProvider>().selectedPokemon ??
        widget.pokemon;
    final mainType = PokemonType.values.firstWhere(
      (e) =>
          e.name.toLowerCase() == widget.pokemon.typeofpokemon[0].toLowerCase(),
      orElse: () => PokemonType.normal,
    );
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        context.read<PokemonDetailProvider>().setSelectedPokemon(null);
      },
      child: Scaffold(
        body: SafeArea(
          child: Consumer<PokemonDetailProvider>(
            builder: (context, value, child) => CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  floating: false,
                  snap: false,
                  pinned: false,
                  leading: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  ),
                  actions: [
                    Consumer<PokemonFavoriteProvider>(
                      builder: (context, value, child) => InkWell(
                        onTap: () {
                          value.toggleFavorite(newDataPokemon.id);

                          if (value.isFavorite(newDataPokemon.id)) {
                            context.read<TabProvider>().setIndex(1);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: SvgPicture.asset(
                            value.isFavorite(newDataPokemon.id)
                                ? 'assets/icons/selected_favorite_2.svg'
                                : 'assets/icons/unselected_favorite_2.svg',
                          ),
                        ),
                      ),
                    )
                  ],
                  backgroundColor: Colors.white,
                  surfaceTintColor: mainType.color,
                  foregroundColor: mainType.color,
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
                                color: mainType.color,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                mainType.iconPath,
                                width: 150,
                                colorFilter: ColorFilter.mode(
                                    Colors.white.withAlpha(40),
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 130,
                            right: 130,
                            child: SizedBox(
                              child: Hero(
                                  tag: 'pokemon-image-${newDataPokemon.id}',
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Transform.scale(
                                      scale: 2,
                                      alignment: Alignment.bottomCenter,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://play.pokemonshowdown.com/sprites/ani/${newDataPokemon.name.toLowerCase()}.gif',
                                        filterQuality: FilterQuality.high,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(Icons.error,
                                                    color: Colors.white)),
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16),
                        Text(newDataPokemon.name,
                            style: AppTextStyles.headline1),
                        Gap(36),
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children: newDataPokemon.typeofpokemon
                              .asMap()
                              .entries
                              .map((entry) {
                            final pokemonElement = entry.value;

                            return CustomElementChipContainer(
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
                          newDataPokemon.xdescription,
                          style: AppTextStyles.bodyLarge,
                        ),
                        Gap(24),
                        Divider(
                          thickness: 1,
                          color: Colors.black.withValues(alpha: 0.1),
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
                          itemCount: newDataPokemon.weaknesses.length,
                          itemBuilder: (context, index) {
                            final pokemonElement =
                                newDataPokemon.weaknesses[index];

                            return CustomElementChipContainer(
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
          ),
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

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              });
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

  Column _buildPokemonStat() {
    return Column(children: [
      Row(
        children: [
          Flexible(
            child: AttributDisplay(
              title: 'WEIGHT',
              data: newDataPokemon.weight,
              iconPath: 'assets/icons/weight.svg',
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'HEIGHT',
              data: newDataPokemon.height,
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
              data: newDataPokemon.category,
              iconPath: 'assets/icons/category.svg',
            ),
          ),
          Gap(24),
          Flexible(
            child: AttributDisplay(
              title: 'ABILITY',
              data: newDataPokemon.abilities[0],
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
              value: parsePercentage(newDataPokemon.malePercentage ?? '0'),
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
                  newDataPokemon.malePercentage ?? '-',
                  style: AppTextStyles.label,
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.female_outlined),
                Text(
                  newDataPokemon.femalePercentage ?? '-',
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
