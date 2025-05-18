import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/constants/pokemon_types.dart';
import 'package:pokedex_app/core/widgets/chip/filter_element_chip.dart';
import 'package:pokedex_app/providers/pokemon_filter_provider.dart';
import 'package:provider/provider.dart';

void showTypeFilterSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (modalContext) {
      String selectedType = context.read<PokemonFilterProvider>().selectedType;

      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(height: 16),
              Text('Pokemon Elements', style: AppTextStyles.subtitle),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: kPokemonTypes.map((pokemonElement) {
                  return InkWell(
                    onTap: () {
                      selectedType = pokemonElement;

                      Navigator.of(modalContext).pop();
                      final provider = context.read<PokemonFilterProvider>();

                      provider.setType(pokemonElement);
                      provider.filterByType(selectedType);
                    },
                    child: Consumer<PokemonFilterProvider>(
                        builder: (context, value, child) {
                      return FilterElementChipContainer(
                        element: pokemonElement,
                        isSelected: selectedType == pokemonElement,
                      );
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  final provider = context.read<PokemonFilterProvider>();
                  await provider.filterByType('All');

                  // Tutup modal dengan animasi
                  Navigator.of(modalContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Hapus Filter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
