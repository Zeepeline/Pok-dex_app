import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';

class FilterElementChipContainer extends StatelessWidget {
  const FilterElementChipContainer({
    super.key,
    required this.element,
    required this.isSelected,
  });

  final String element;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final mainType = PokemonType.values.firstWhere(
      (e) => e.name.toLowerCase() == element.toLowerCase(),
      orElse: () => PokemonType.normal,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? mainType.color : Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? mainType.color : Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              mainType.iconPath,
              colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : Colors.black, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            element,
            style: AppTextStyles.caption.copyWith(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
