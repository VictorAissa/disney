import 'package:disney/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statpage extends StatefulWidget {
  const Statpage({Key? key}) : super(key: key);

  @override
  _StatpageState createState() => _StatpageState();
}

class _StatpageState extends State<Statpage> {
  List<String> _availableFilms = [];
  String? _selectedFilm;
  int? _persoIn;
  int? _persoOnly;
  int? _persoOut;
  late PersoState persoState;

  @override
  void initState() {
    super.initState();
    persoState = Provider.of<PersoState>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateFilmsList();
    });
  }

  void _generateFilmsList() {
    Set<String> uniqueFilms = {};

    for (var perso in persoState.persos) {
      for (var film in perso.films) {
        uniqueFilms.add(film);
      }
    }

    setState(() {
      _availableFilms = uniqueFilms.toList()..sort();
    });
  }

  void _getPersoIn() {
    if (_availableFilms.isEmpty || _selectedFilm == null) return;

    int count = persoState.persos
        .where((perso) => perso.films.contains(_selectedFilm))
        .length;

    setState(() {
      _persoIn = count;
    });
  }

  void _getPersoOnly() {
    if (_availableFilms.isEmpty || _selectedFilm == null) return;

    int count = persoState.persos
        .where((perso) =>
            perso.films.contains(_selectedFilm) && perso.films.length == 1)
        .length;

    setState(() {
      _persoOnly = count;
    });
  }

  void _getPersoOut() {
    if (_availableFilms.isEmpty || _selectedFilm == null) return;

    int count = persoState.persos
        .where((perso) =>
            perso.films.contains(_selectedFilm) && perso.films.length > 1)
        .length;

    setState(() {
      _persoOut = count;
    });
  }

  void _calculateAllStats() {
    _getPersoIn();
    _getPersoOnly();
    _getPersoOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Statistiques"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Choisissez un film",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 16),

                // Dropdown
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedFilm,
                    isExpanded: true,
                    hint: const Text("Sélectionner un film"),
                    underline: const SizedBox(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedFilm = newValue;
                        });
                        _calculateAllStats();
                      }
                    },
                    items: _availableFilms
                        .map<DropdownMenuItem<String>>((String film) {
                      return DropdownMenuItem<String>(
                        value: film,
                        child: Text(film),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 30),

                if (_selectedFilm != null) ...[
                  Text(
                    _selectedFilm!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatRow("Nombre de personnages dans ce film:",
                              _persoIn == null ? "inconnu" : "$_persoIn"),
                          const Divider(height: 24),
                          _buildStatRow(
                              "Nombre de personnages uniquement dans ce film:",
                              _persoOnly == null ? "inconnu" : "$_persoOnly"),
                          const Divider(height: 24),
                          _buildStatRow(
                              "Nombre de personnages apparaissant aussi dans d'autres films:",
                              _persoOut == null ? "inconnu" : "$_persoOut"),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildStatRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        flex: 7,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        flex: 3,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.indigo,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
