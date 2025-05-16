import 'package:equatable/equatable.dart';

class PokemonModel extends Equatable {
  final String name;
  final String id;
  final String imageUrl;
  final String xdescription;
  final String ydescription;
  final String height;
  final String category;
  final String weight;
  final List<String> typeofpokemon;
  final List<String> weaknesses;
  final List<String> evolutions;
  final List<String> abilities;
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;
  final int total;
  final String? malePercentage;
  final String? femalePercentage;
  final int genderless;
  final String cycles;
  final String eggGroups;
  final String evolvedFrom;
  final String reason;
  final String baseExp;

  const PokemonModel({
    required this.name,
    required this.id,
    required this.imageUrl,
    required this.xdescription,
    required this.ydescription,
    required this.height,
    required this.category,
    required this.weight,
    required this.typeofpokemon,
    required this.weaknesses,
    required this.evolutions,
    required this.abilities,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
    required this.total,
    required this.malePercentage,
    required this.femalePercentage,
    required this.genderless,
    required this.cycles,
    required this.eggGroups,
    required this.evolvedFrom,
    required this.reason,
    required this.baseExp,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'] as String,
      id: json['id'] as String,
      imageUrl: json['imageurl'] as String,
      xdescription: json['xdescription'] as String,
      ydescription: json['ydescription'] as String,
      height: json['height'] as String,
      category: json['category'] as String,
      weight: json['weight'] as String,
      typeofpokemon: (json['typeofpokemon'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      evolutions: (json['evolutions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      abilities:
          (json['abilities'] as List<dynamic>).map((e) => e as String).toList(),
      hp: json['hp'] as int,
      attack: json['attack'] as int,
      defense: json['defense'] as int,
      specialAttack: json['special_attack'] as int,
      specialDefense: json['special_defense'] as int,
      speed: json['speed'] as int,
      total: json['total'] as int,
      malePercentage: json['male_percentage'] as String?,
      femalePercentage: json['female_percentage'] as String?,
      genderless: json['genderless'] as int,
      cycles: json['cycles'] as String,
      eggGroups: json['egg_groups'] as String,
      evolvedFrom: json['evolvedfrom'] as String,
      reason: json['reason'] as String,
      baseExp: json['base_exp'] as String,
    );
  }

  @override
  List<Object?> get props => [
        name,
        id,
        imageUrl,
        xdescription,
        ydescription,
        height,
        category,
        weight,
        typeofpokemon,
        weaknesses,
        evolutions,
        abilities,
        hp,
        attack,
        defense,
        specialAttack,
        specialDefense,
        speed,
        total,
        malePercentage,
        femalePercentage,
        genderless,
        cycles,
        eggGroups,
        evolvedFrom,
        reason,
      ];
}
