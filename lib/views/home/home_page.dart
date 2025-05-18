import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_colors.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';
import 'package:pokedex_app/core/helpers/debouncer_helpers.dart';
import 'package:pokedex_app/core/widgets/card/pokemon_card_shimmer.dart';
import 'package:pokedex_app/core/widgets/modal/filter_pokemon_type_bottom_sheet.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_favorite_provider.dart';
import 'package:pokedex_app/providers/pokemon_filter_provider.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:pokedex_app/providers/pokemon_search_provider.dart';
import 'package:pokedex_app/views/home/pokemon_listview.dart';
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

  void _setupInfiniteScroll() {
    _scrollController.addListener(() {
      final pokemonProvider = context.read<PokemonProvider>();
      final filterProvider = context.read<PokemonFilterProvider>();
      if (_scrollController.position.maxScrollExtent <=
          _scrollController.position.pixels) {
        filterProvider.selectedType != 'All'
            ? filterProvider.fetchNextPage()
            : pokemonProvider.fetchNextPokemonPage();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _debouncer = Debouncer(milliseconds: 400);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false).initData();
    });

    _setupInfiniteScroll();
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
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          const Gap(16),
          _buildFilterType(),
          const Gap(16),
          isAnyLoading(context)
              ? buildShimmerList()
              : Consumer4<PokemonProvider, PokemonSearchProvider,
                  PokemonFavoriteProvider, PokemonFilterProvider>(
                  builder: (context, pokemonProvider, searchProvider,
                      favoriteProvider, filterProvider, _) {
                    List<PokemonModel> pokemonList = getPokemonList(
                      all: pokemonProvider,
                      search: searchProvider,
                      filter: filterProvider,
                    );

                    return pokemonList.isEmpty
                        ? _buildEmptyState()
                        : PokemonListView(
                            isLoadingMore: pokemonProvider.isLoadingMore,
                            pokemonList: pokemonList,
                          );
                  },
                ),
          const Gap(16),
        ],
      ),
    );
  }

  Center _buildEmptyState() {
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
          Gap(16),
          Text(
            'No Pokemon found',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    ));
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
          color: context
              .watch<PokemonFilterProvider>()
              .selectedType
              .asPokemonType
              .color,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${context.watch<PokemonFilterProvider>().selectedType} Type',
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
            color: AppColors.water,
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
