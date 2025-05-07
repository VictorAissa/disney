import 'package:disney/data/Perso.dart';
import 'package:disney/main.dart';
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
      ),
      body: appState.isLoading 
        ? Center(child: CircularProgressIndicator())
        : appState.error != null 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${appState.error}'),
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
    );
  }
}