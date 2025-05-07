import 'package:disney/data/Perso.dart';
import 'package:disney/screen/PersoDetailPage.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  final Perso perso;

  const MainCard({
    super.key,
    required this.perso,
  });

  String _cleanImageUrl(String url) {
    if (url.isEmpty) {
      return 'https://picsum.photos/200/300?grayscale';
    }

    if (url.contains('?')) {
      return url.split('?')[0];
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                width: 100,
                height: 80,
                child: Image.network(
                  _cleanImageUrl(perso.imageUrl),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey[700]),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        perso.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      'Films : ${perso.films.length.toString()}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PersoDetailPage(
                              perso: perso,
                            )));
              },
              icon: const Icon(
                Icons.chevron_right,
                color: Colors.blueGrey,
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
