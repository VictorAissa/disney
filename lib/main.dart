import 'package:disney/data/Perso.dart';
import 'package:disney/screen/HomePage.dart';
import 'package:disney/service/PersoService.dart';
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

  List<Perso> _persos = [];
  bool _isLoading = false;
  String? _error;

  List<Perso> get persos => _persos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchPersos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _persos = await _persoService.fetchPersos();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
