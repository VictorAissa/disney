class Perso {
  final int? _id;
  final List<String> films;
  final List<String> shortFilms;
  final List<String> tvShows;
  final List<String> videoGames;
  final List<String> parkAttractions;
  final List<String> allies;
  final List<String> enemies;
  final String sourceUrl;
  final String name;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  final String url;
  final int? __v;

  Perso(
      this._id,
      this.films,
      this.shortFilms,
      this.tvShows,
      this.videoGames,
      this.parkAttractions,
      this.allies,
      this.enemies,
      this.sourceUrl,
      this.name,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.url,
      this.__v);

  factory Perso.fromJson(Map<String, dynamic> json) {
    return Perso(
      json['_id'],
      _parseStringList(json['films']),
      _parseStringList(json['shortFilms']),
      _parseStringList(json['tvShows']),
      _parseStringList(json['videoGames']),
      _parseStringList(json['parkAttractions']),
      _parseStringList(json['allies']),
      _parseStringList(json['enemies']),
      json['sourceUrl'] ?? '',
      json['name'] ?? '',
      json['imageUrl'] ?? '',
      json['createdAt'] ?? '',
      json['updatedAt'] ?? '',
      json['url'] ?? '',
      json['__v'],
    );
  }

  static List<String> _parseStringList(dynamic list) {
    if (list == null) return [];
    return (list as List).map((item) => item.toString()).toList();
  }
}
