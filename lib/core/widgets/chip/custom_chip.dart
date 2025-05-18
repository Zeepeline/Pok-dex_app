import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex_app/core/constants/app_text_styles.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';
import 'package:pokedex_app/core/extension/pokemon_type_extension.dart';

class CustomElementChipContainer extends StatelessWidget {
  const CustomElementChipContainer({
    super.key,
    required this.element,
    required this.type,
  });

  final String element;
  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: SvgPicture.asset(
              type.iconPath,
              colorFilter: ColorFilter.mode(type.color, BlendMode.srcIn),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            element,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
