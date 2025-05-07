import 'package:disney/data/Perso.dart';
import 'package:disney/main.dart';
import 'package:disney/screen/SearchPage.dart';
import 'package:disney/screen/StatPage.dart';
import 'package:disney/screen/UserPersoPage.dart';
import 'package:disney/share/MainCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PersoState>(context, listen: false).fetchPersos();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PersoState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Personnages'),
        centerTitle: true,
        actions: [
          if (appState.isFiltered)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => appState.resetFilters(),
              tooltip: 'Effacer la recherche',
            ),
        ],
      ),
      body: appState.isLoading
          ? Center(child: CircularProgressIndicator())
          : appState.persos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Aucun personnage à afficher.'),
                      ElevatedButton(
                        onPressed: () => appState.fetchPersos(),
                        child: Text('Réessayer'),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: appState.persos
                      .map((perso) => MainCard(perso: perso))
                      .toList(),
                ),
      floatingActionButton: appState.isFiltered
          ? FloatingActionButton.extended(
              onPressed: () => appState.resetFilters(),
              label: const Text('Réinitialiser'),
              icon: const Icon(Icons.clear),
              backgroundColor: Theme.of(context).colorScheme.error,
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));
              },
              label: const Text('Rechercher'),
              icon: const Icon(Icons.search),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Statpage()));
              },
              icon: Icon(Icons.pie_chart),
              label: Text('Statistiques'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Userpersopage()));
              },
              icon: Icon(Icons.person),
              label: Text('Mon perso'),
            ),
          ],
        ),
      ),
    );
  }
}
