import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/widgets/pokemon_card.dart';
import 'package:pokedex_app/providers/pokemon_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PokemonProvider>(context, listen: false).initData();
    });

    _scrollController.addListener(() {
      final provider = Provider.of<PokemonProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        provider.fetchNextPokemonPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(88),
        child: Container(
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildSearchField(),
              ),
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
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Consumer<PokemonProvider>(
                      builder: (context, provider, child) => ListView.separated(
                          shrinkWrap: true,
                          itemCount: provider.pokemonList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => Gap(16),
                          itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  context.read<AppState>().selectPokemon(
                                      provider.pokemonList[index]);
                                },
                                child: PokemonCard(
                                  pokemon: provider.pokemonList[index],
                                ),
                              )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildFilterType() {
    return Container(
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
    );
  }

  TextField _buildSearchField() {
    return TextField(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
