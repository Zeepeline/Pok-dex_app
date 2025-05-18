import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/pokemon_model.dart';
import 'package:pokedex_app/providers/pokemon_detail_provider.dart';
import 'package:pokedex_app/views/detail/detail_pokemon_appbar.dart';
import 'package:pokedex_app/views/detail/detail_pokemon_content.dart';
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
                PokemonDetailAppBar(
                  pokemon: newDataPokemon,
                  onBack: () {
                    context
                        .read<PokemonDetailProvider>()
                        .setSelectedPokemon(null);
                    Navigator.of(context).pop();
                  },
                ),
                DetailPokemonContent(
                  pokemon: newDataPokemon,
                  onOtherPokemonTap: () {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
