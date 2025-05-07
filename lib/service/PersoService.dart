import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:disney/data/Perso.dart';

class PersoService {
  final String baseUrl = 'https://api.disneyapi.dev/character?pageSize=100';

  Future<List<Perso>> fetchPersos() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> persosJson = jsonResponse['data'];

      return persosJson.map((json) => Perso.fromJson(json)).toList();
    } else {
      throw Exception('Échec du chargement des personnages Disney');
    }
  }
}
