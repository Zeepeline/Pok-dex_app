import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_colors.dart';
import 'package:pokedex_app/core/enums/pokemon_enum.dart';

extension PokemonTypeExtension on PokemonType {
  Color get color {
    switch (this) {
      case PokemonType.water:
        return AppColors.water;
      case PokemonType.dragon:
        return AppColors.dragon;
      case PokemonType.electric:
        return AppColors.electric;
      case PokemonType.fairy:
        return AppColors.fairy;
      case PokemonType.ghost:
        return AppColors.ghost;
      case PokemonType.fire:
        return AppColors.fire;
      case PokemonType.ice:
        return AppColors.ice;
      case PokemonType.grass:
        return AppColors.grass;
      case PokemonType.bug:
        return AppColors.insect;
      case PokemonType.fighting:
        return AppColors.fighter;
      case PokemonType.normal:
        return AppColors.normal;
      case PokemonType.dark:
        return AppColors.nocturnal;
      case PokemonType.steel:
        return AppColors.metal;
      case PokemonType.rock:
        return AppColors.stone;
      case PokemonType.psychic:
        return AppColors.customPsychic;
      case PokemonType.ground:
        return AppColors.terrestrial;
      case PokemonType.poison:
        return AppColors.poisonous;
      case PokemonType.flying:
        return AppColors.flying;
    }
  }

  String get iconPath {
    switch (this) {
      case PokemonType.water:
        return 'assets/icons/water_element.svg';
      case PokemonType.fire:
        return 'assets/icons/fire_element.svg';
      case PokemonType.electric:
        return 'assets/icons/electric_element.svg';
      case PokemonType.ice:
        return 'assets/icons/ice_element.svg';
      case PokemonType.grass:
        return 'assets/icons/grass_element.svg';
      case PokemonType.rock:
        return 'assets/icons/rock_element.svg';
      case PokemonType.psychic:
        return 'assets/icons/psychic_element.svg';
      case PokemonType.bug:
        return 'assets/icons/insect_element.svg';
      case PokemonType.flying:
        return 'assets/icons/flying_element.svg';
      case PokemonType.fairy:
        return 'assets/icons/fairy_element.svg';
      case PokemonType.ghost:
        return 'assets/icons/ghost_element.svg';
      case PokemonType.dragon:
        return 'assets/icons/dragon_element.svg';
      case PokemonType.normal:
        return 'assets/icons/normal_element.svg';
      case PokemonType.fighting:
        return 'assets/icons/fighter_element.svg';
      case PokemonType.dark:
        return 'assets/icons/nocturnal_element.svg';
      case PokemonType.steel:
        return 'assets/icons/metal_element.svg';
      case PokemonType.ground:
        return 'assets/icons/terrestrial_element.svg';
      case PokemonType.poison:
        return 'assets/icons/poisonous_element.svg';
    }
  }
}
