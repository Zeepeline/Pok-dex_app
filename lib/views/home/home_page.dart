import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/helpers/debouncer_helpers.dart';
import 'package:pokedex_app/core/helpers/toast_helpers.dart';
import 'package:pokedex_app/core/widgets/filter_pokemon_type_bottom_sheet.dart';
import 'package:pokedex_app/core/widgets/pokemon_card.dart';
import 'package:pokedex_app/core/widgets/pokemon_card_shimmer.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/pokemon_filter_provider.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:pokedex_app/providers/pokemon_search_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late Debouncer _debouncer;

  bool isAnyLoading(BuildContext context) {
    final pokemonProvider = context.watch<PokemonProvider>();
    final searchProvider = context.watch<PokemonSearchProvider>();
    final filterProvider = context.watch<PokemonFilterProvider>();
    return pokemonProvider.isLoading ||
        searchProvider.isLoading ||
        filterProvider.isLoading;
  }

  List<PokemonModel> getPokemonList({
    required PokemonProvider all,
    required PokemonSearchProvider search,
    required PokemonFilterProvider filter,
  }) {
    if (search.searchText.isNotEmpty) return search.searchResult;
    if (filter.selectedType != 'All') return filter.visibleFilteredPokemon;
    return all.pokemonList;
  }

  @override
  void initState() {
    super.initState();

    _debouncer = Debouncer(milliseconds: 400);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false).initData();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<PokemonProvider>(context, listen: false);
      final filterProvider =
          Provider.of<PokemonFilterProvider>(context, listen: false);
      if (_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels <=
          100) {
        if (filterProvider.selectedType != 'All') {
          filterProvider.fetchNextPage();
        } else {
          provider.fetchNextPokemonPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Container(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
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
              alignment: Alignment.bottomCenter,
              child: _buildSearchField(),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              Gap(16),
              _buildFilterType(),
              Gap(16),
              isAnyLoading(context)
                  ? Center(
                      child: buildShimmerList(),
                    )
                  : Consumer4<PokemonProvider, PokemonSearchProvider,
                      PokemonFavoriteProvider, PokemonFilterProvider>(
                      builder: (context, pokemonProvider, searchProvider,
                          favoriteProvider, filterProvider, _) {
                        final isSearching =
                            searchProvider.searchText.isNotEmpty;
                        List<PokemonModel> pokemonList;

                        if (isSearching) {
                          pokemonList = searchProvider.searchResult;
                        } else if (filterProvider.selectedType != 'All') {
                          pokemonList = filterProvider.visibleFilteredPokemon;
                        } else {
                          pokemonList = pokemonProvider.pokemonList;
                        }

                        return pokemonList.isEmpty
                            ? Center(
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
                                    Gap(16),
                                    Text(
                                      'No Pokemon found',
                                      style: AppTextStyles.subtitle,
                                    ),
                                  ],
                                ),
                              ))
                            : ListView.separated(
                                shrinkWrap: true,
                                cacheExtent: 500,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: pokemonList.length +
                                    (pokemonProvider.isLoadingMore ? 1 : 0),
                                separatorBuilder: (_, __) => Gap(16),
                                itemBuilder: (context, index) {
                                  if (index == pokemonList.length) {
                                    return const PokemonCardShimmer();
                                  }
                                  final pokemon = pokemonList[index];
                                  final isFav =
                                      favoriteProvider.isFavorite(pokemon.id);
                                  return InkWell(
                                    onTap: () {
                                      context
                                          .read<AppState>()
                                          .selectPokemon(pokemon);
                                    },
                                    child: PokemonCard(
                                      pokemon: pokemon,
                                      isFavorite: isFav,
                                      onFavoriteTap: () {
                                        favoriteProvider
                                            .toggleFavorite(pokemon.id);
                                        if (!isFav) {
                                          successToast(
                                              context,
                                              'Added to favorites',
                                              '${pokemon.name} added to favorites!');
                                        } else {
                                          failToast(
                                              context,
                                              'Removed from favorites',
                                              '${pokemon.name} removed from favorites!');
                                        }
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

  Widget _buildFilterType() {
    return InkWell(
      onTap: () {
        showTypeFilterSheet(context);
      },
      child: Container(
        width: double.infinity,
        height: 49,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(49),
          color: Color(0xFF333333),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'All Type',
                style: AppTextStyles.baseText.copyWith(color: Colors.white),
              ),
              Gap(8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }

  TextField _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Find the Pokemon',
        alignLabelWithHint: true,
        prefixIconConstraints: BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/icons/search.svg',
            fit: BoxFit.contain,
          ),
        ),
        hintStyle: AppTextStyles.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
      onChanged: (value) {
        _debouncer.run(() {
          context.read<PokemonSearchProvider>().fetchByNamesOrIds(value);
        });
      },
    );
  }

  Widget buildShimmerList() {
    return const Column(
      children: [
        PokemonCardShimmer(),
        Gap(16),
        PokemonCardShimmer(),
        Gap(16),
        PokemonCardShimmer(),
        Gap(16),
        PokemonCardShimmer(),
        Gap(16),
        PokemonCardShimmer(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
