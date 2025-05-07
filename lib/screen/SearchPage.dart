import 'package:disney/data/Perso.dart';
import 'package:disney/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _searchInFilms = true;
  bool _searchInShows = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Recherche'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un personnage',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _handleSearch(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: (_) => _handleSearch(context),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _searchInFilms,
                  onChanged: (value) {
                    setState(() {
                      _searchInFilms = value ?? true;
                    });
                  },
                ),
                const Text('Rechercher dans les films'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _searchInShows,
                  onChanged: (value) {
                    setState(() {
                      _searchInShows = value ?? true;
                    });
                  },
                ),
                const Text('Rechercher dans les séries'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _handleSearch(context),
              child: const Text('Rechercher'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSearch(BuildContext context) {
    String query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      // Si la recherche est vide, on ne fait rien
      return;
    }

    // Récupérer l'état des personnages
    final persoState = Provider.of<PersoState>(context, listen: false);

    // Appliquer le filtre
    persoState.filterPersos(
      query: query,
      searchInFilms: _searchInFilms,
      searchInShows: _searchInShows,
    );

    // Revenir à la page précédente
    Navigator.pop(context);
  }
}
