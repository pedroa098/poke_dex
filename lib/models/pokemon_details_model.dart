class PokemonDetails {
  final int id;
  final String name;
  final String imageUrl;
  final double height;
  final double weight;
  final List<String> abilities;
  final List<String> types;

  PokemonDetails({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.types,
  });

  factory PokemonDetails.fromMap(Map<String, dynamic> map) {
    return PokemonDetails(
      id: map['id'],
      name: map['name'],
      imageUrl: map['sprites']['other']['official-artwork']['front_default'],
      height: map['height'] / 10, // Convertendo de decímetros para metros
      weight: map['weight'] / 10, // Convertendo de hectogramas para quilogramas
      abilities: (map['abilities'] as List)
          .map((ability) => ability['ability']['name'] as String)
          .toList(),
      types: (map['types'] as List) // Extraindo os tipos
          .map((type) => type['type']['name'] as String)
          .toList(),
    );
  }
}