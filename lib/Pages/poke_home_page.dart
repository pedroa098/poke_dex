import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/models/pokemon_list_model.dart';
import 'package:poke_dex/models/pokemon_model.dart';
import 'pokemon_detail_page.dart';

class PokeHomePage extends StatefulWidget {
  const PokeHomePage({super.key});

  @override
  _PokeHomePageState createState() => _PokeHomePageState();
}

class _PokeHomePageState extends State<PokeHomePage> {
  List<Pokemon> _pokemonList = [];
  List<Pokemon> _filteredPokemonList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  Future<void> _fetchPokemons() async {
    final dio = Dio();
    try {
      final response = await dio
          .get('https://pokeapi.co/api/v2/pokemon?limit=1000&offset=0');
      var model = PokemonListModel.fromMap(response.data);
      setState(() {
        _pokemonList = model.results;
        _filteredPokemonList = _pokemonList;
      });
    } catch (e) {
      throw Exception("Erro ao carregar Pokémon: $e");
    }
  }

  void _filterPokemons(String query) {
    setState(() {
      _filteredPokemonList = _pokemonList
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar Pokémon',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterPokemons,
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return _filteredPokemonList.isEmpty
        ? _buildLoadingIndicator()
        : _buildPokemonList(_filteredPokemonList);
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(
        "Erro: $errorMessage",
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text("Nenhum Pokémon encontrado."),
    );
  }

  Widget _buildPokemonList(List<Pokemon> pokemonList) {
    return ListView.builder(
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        var pokemon = pokemonList[index];
        return _buildPokemonListItem(pokemon, context);
      },
    );
  }

  Widget _buildPokemonListItem(Pokemon pokemon, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.catching_pokemon),
      title: Text(
        pokemon.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      onTap: () {
        // Navega para a página de detalhes do Pokémon
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailPage(pokemonUrl: pokemon.url),
          ),
        );
      },
    );
  }
}
