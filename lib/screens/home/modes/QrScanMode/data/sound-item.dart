class SoundItem {
  final String id;
  final String title;
  final String asset;
  final int points;

  /// When set, audio is streamed from this URL (e.g. Firebase Storage) instead of [asset].
  final String? networkUrl;

  /// When set (http(s) only), file was downloaded before navigation; use [setFilePath] first.
  final String? prefetchedLocalPath;

  const SoundItem({
    required this.id,
    required this.title,
    required this.asset,
    required this.points,
    this.networkUrl,
    this.prefetchedLocalPath,
  });

  bool get playsFromNetwork =>
      networkUrl != null && networkUrl!.trim().isNotEmpty;

  bool get hasPrefetchedFile =>
      prefetchedLocalPath != null && prefetchedLocalPath!.trim().isNotEmpty;
}
