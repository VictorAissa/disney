import 'dart:io';

import 'package:disney/data/Perso.dart';
import 'package:disney/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserPersoPage extends StatefulWidget {
  @override
  State<UserPersoPage> createState() => _UserpersopageState();
}

class _UserpersopageState extends State<UserPersoPage> {
  File? _image;
  final picker = ImagePicker();
  Perso? _matchedPerso;
  double _matchPercentage = 0.0;
  bool _isLoading = false;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _matchedPerso = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Mon personnage"),
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
                  "Téléchargez une photo",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // Aperçu
                ImagePreview(image: _image, onTap: getImage),

                const SizedBox(height: 24),

                if (_image != null)
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _isLoading = true;
                              // Simulation de traitement (à remplacer)
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  _isLoading = false;
                                  _matchedPerso = Provider.of<PersoState>(
                                          context,
                                          listen: false)
                                      .persos
                                      .first;
                                  _matchPercentage = 78.5;
                                });
                              });
                            });
                          },
                    child: const Text("Trouver mon double"),
                  ),

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CircularProgressIndicator(),
                  ),

                const SizedBox(height: 32),

                // Résultat
                if (_matchedPerso != null)
                  MatchResultCard(
                    perso: _matchedPerso!,
                    percentage: _matchPercentage,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePreview({
    Key? key,
    required this.image,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: image == null
          ? Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  const Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image!,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class MatchResultCard extends StatelessWidget {
  final Perso perso;
  final double percentage;

  const MatchResultCard({
    Key? key,
    required this.perso,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                perso.imageUrl,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    width: 150,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              perso.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Ressemblance: ${percentage.toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
