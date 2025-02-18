import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:poke_dex/models/pokemon_list_model.dart';
import 'package:poke_dex/models/pokemon_model.dart';
import 'pokemon_detail_page.dart'; // Importe a nova página

class PokeHomePage extends StatelessWidget {
  const PokeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
      ),
      body: _buildBody(),
    );
  }

  Future<List<Pokemon>> _fetchPokemons() async {
    final dio = Dio();
    try {
      final response =
          await dio.get('https://pokeapi.co/api/v2/pokemon?limit=100&offset=0');
      var model = PokemonListModel.fromMap(response.data);
      await Future.delayed(
          const Duration(seconds: 2)); // Simula um delay para teste
      return model.results;
    } catch (e) {
      throw Exception("Erro ao carregar Pokémon: $e");
    }
  }

  Widget _buildBody() {
    return FutureBuilder<List<Pokemon>>(
      future: _fetchPokemons(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyWidget();
        } else {
          return _buildPokemonList(snapshot.data!);
        }
      },
    );
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
      leading: const Icon(Icons.catching_pokemon_rounded),
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
