import 'package:disney/data/Perso.dart';
import 'package:disney/screen/HomePage.dart';
import 'package:disney/service/PersoService.dart';
import 'package:disney/service/SnackbarService.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PersoState(),
      child: MaterialApp(
        title: 'Disney',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomePage(),
      ),
    );
  }
}

class PersoState extends ChangeNotifier {
  final PersoService _persoService = PersoService();

  List<Perso> _allPersos = [];
  List<Perso> _persos = [];
  bool _isLoading = false;
  String? _error;
  String _currentFilter = '';

  List<Perso> get persos => _persos;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isFiltered => _currentFilter.isNotEmpty;
  String get currentFilter => _currentFilter;

  Future<void> fetchPersos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPersos = await _persoService.fetchPersos();
      _persos = List.from(_allPersos);
      _currentFilter = '';
      _error = null;
    } catch (e) {
      _error = e.toString();
      _allPersos = [];
      _persos = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterPersos({
    required String query,
    bool searchInFilms = true,
    bool searchInShows = true,
  }) {
    if (query.isEmpty) {
      _persos = List.from(_allPersos);
      _currentFilter = '';
    } else {
      _currentFilter = query;
      _persos = _allPersos.where((perso) {
        if (perso.name.toLowerCase().contains(query)) {
          return true;
        }

        if (searchInFilms) {
          for (var film in perso.films) {
            if (film.toLowerCase().contains(query)) {
              return true;
            }
          }
        }

        if (searchInShows) {
          for (var show in perso.tvShows) {
            if (show.toLowerCase().contains(query)) {
              return true;
            }
          }
        }

        return false;
      }).toList();
    }

    notifyListeners();
  }

  void resetFilters() {
    _persos = List.from(_allPersos);
    _currentFilter = '';
    notifyListeners();
  }
}
