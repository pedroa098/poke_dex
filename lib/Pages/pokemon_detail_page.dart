import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/pokemon_details_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonUrl;

  const PokemonDetailPage({super.key, required this.pokemonUrl});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late Future<PokemonDetails> _pokemonDetails;

  @override
  void initState() {
    super.initState();
    _pokemonDetails = _fetchPokemonDetails();
  }

  Future<PokemonDetails> _fetchPokemonDetails() async {
    final dio = Dio();
    final response = await dio.get(widget.pokemonUrl);
    return PokemonDetails.fromMap(response.data);
  }

  /// Retorna a cor de fundo com base no tipo do Pokémon
  Color _getBackgroundColor(List<String> types) {
    if (types.isEmpty) return Colors.grey; // Cor padrão se não houver tipos

    // Mapeia o primeiro tipo para uma cor
    switch (types[0]) {
      case 'grass':
        return Colors.green.shade100;
      case 'fire':
        return Colors.red.shade100;
      case 'water':
        return Colors.blue.shade100;
      case 'electric':
        return Colors.yellow.shade100;
      case 'poison':
        return Colors.purple.shade100;
      case 'bug':
        return Colors.lightGreen.shade100;
      case 'flying':
        return Colors.lightBlue.shade100;
      case 'normal':
        return const Color.fromARGB(255, 201, 199, 199);
      case 'fighting':
        return Colors.orange.shade100;
      case 'rock':
        return Colors.brown.shade100;
      case 'psychic':
        return Colors.deepPurpleAccent.shade100;
      case 'fairy':
        return const Color.fromARGB(255, 214, 106, 182);

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetails>(
      future: _pokemonDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Erro: ${snapshot.error}")),
          );
        } else if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Nenhum dado encontrado.")),
          );
        } else {
          var pokemon = snapshot.data!;
          Color backgroundColor = _getBackgroundColor(pokemon.types);

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: const Text("Detalhes do Pokémon"),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Título
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Imagem do Pokémon
                        Image.network(
                          pokemon.imageUrl,
                          width: 190,
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        // Tipos do Pokémon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: pokemon.types.map((type) {
                            IconData icon;
                            Color color;

                            // ícones e cores
                            switch (type) {
                              case 'grass':
                                icon = Icons.grass;
                                color = Colors.green;
                                break;
                              case 'fire':
                                icon = Icons.local_fire_department;
                                color = Colors.red;
                                break;
                              case 'water':
                                icon = Icons.water_drop;
                                color = Colors.blue;
                                break;
                              case 'electric':
                                icon = Icons.bolt;
                                color = Colors.yellow;
                                break;
                              case 'poison':
                                icon = FontAwesomeIcons.skullCrossbones;
                                color = Colors.deepPurple;
                                break;
                              case 'bug':
                                icon = FontAwesomeIcons.bug;
                                color = Colors.lightGreen;
                                break;
                              case 'flying':
                                icon = FontAwesomeIcons.feather;
                                color = Colors.lightBlueAccent;
                                break;
                              case 'normal':
                                icon = FontAwesomeIcons.circle;
                                color = Colors.grey;
                                break;
                              case 'fighting':
                                icon = FontAwesomeIcons.handBackFist;
                                color = const Color.fromARGB(255, 219, 31, 31);
                                break;
                              case 'rock':
                                icon = FontAwesomeIcons.gem;
                                color = const Color.fromARGB(255, 209, 88, 8);
                                break;
                              case 'ground':
                                icon = Icons.terrain_outlined;
                                color = Colors.redAccent;
                                break;
                              case 'ghost':
                                icon = FontAwesomeIcons.ghost;
                                color = const Color.fromARGB(255, 80, 47, 88);
                                break;
                              case 'psychic':
                                icon = FontAwesomeIcons.eye;
                                color = const Color.fromARGB(255, 211, 46, 189);
                                break;
                              case 'fairy':
                                icon = FontAwesomeIcons.starOfDavid;
                                color = const Color.fromARGB(255, 204, 85, 168);
                                break;
                              default:
                                icon = Icons.question_mark;
                                color = Colors.grey;
                            }

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Icon(icon, color: color, size: 30),
                                  Text(type.toUpperCase()),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        // Cards de informações
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Card de informações básicas
                            Card(
                              elevation: 4,
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Informações",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text("Altura: ${pokemon.height} m"),
                                    Text("Peso: ${pokemon.weight} kg"),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // carta de habilidades
                            Card(
                              elevation: 4,
                              child: Container(
                                width: 150,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Ataques",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ...pokemon.abilities
                                        .map((ability) => Text("- $ability"))
                                        .toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
