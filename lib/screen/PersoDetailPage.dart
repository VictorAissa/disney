import 'package:disney/data/Perso.dart';
import 'package:flutter/material.dart';

class PersoDetailPage extends StatelessWidget {
  final Perso perso;

  const PersoDetailPage({
    Key? key,
    required this.perso,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(perso.name),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(64.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      perso.imageUrl,
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          width: 250,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Films",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...perso.films
                      .map((film) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "• $film",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ))
                      .toList(),
                  const SizedBox(height: 24),
                  const Text(
                    "Séries TV",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...perso.tvShows.isEmpty
                      ? [const Text("Aucune série TV")]
                      : perso.tvShows
                          .map((show) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "• $show",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ))
                          .toList(),
                ],
              ),
            ),
          ),
        ));
  }
}
