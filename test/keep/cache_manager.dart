//
// class CachedTileImageProvider extends ImageProvider<CachedTileImageProvider> {
//   final String url;
//   final CacheManager cacheManager;
//
//   CachedTileImageProvider(this.url, {CacheManager? cacheManager})
//       : cacheManager = cacheManager ?? DefaultCacheManager();
//
//   @override
//   ImageStreamCompleter load(CachedTileImageProvider key, DecoderCallback decode) {
//     return MultiFrameImageStreamCompleter(
//       codec: _loadAsync(key, decode),
//       scale: 1.0,
//     );
//   }
//
//   Future<Codec> _loadAsync(CachedTileImageProvider key, DecoderCallback decode) async {
//     final file = await key.cacheManager.getSingleFile(key.url);
//     if (file == null || !file.existsSync()) {
//       throw Exception("Tile Image not found in cache and network.");
//     }
//     final bytes = await file.readAsBytes();
//     if (bytes.lengthInBytes == 0) {
//       throw Exception("Empty tile image retrieved.");
//     }
//     return decode(bytes);
//   }
//
//   @override
//   Future<CachedTileImageProvider> obtainKey(ImageConfiguration configuration) {
//     return Future.value(this);
//   }
// }
//
// class CachingNetworkTileProvider extends TileProvider {
//   final CacheManager cacheManager;
//   final String urlTemplate;
//
//   CachingNetworkTileProvider({
//     CacheManager? cacheManager,
//     required this.urlTemplate,
//   }) : cacheManager = cacheManager ?? DefaultCacheManager();
//
//   @override
//   ImageProvider<Object> getImage(TileCoordinates coordinates, TileLayer options) {
//     final url = _url(coordinates, options, urlTemplate);
//     return CachedTileImageProvider(
//       url,
//       cacheManager: cacheManager,
//     );
//   }
//
//   String _url(TileCoordinates coordinates, TileLayer options, String urlTemplate) {
//     return urlTemplate
//         .replaceAll('{z}', '${coordinates.z}')
//         .replaceAll('{x}', '${coordinates.x}')
//         .replaceAll('{y}', '${coordinates.y}');
//   }
// }
//
// class CustomCacheManager extends CacheManager {
//   static const key = "customCacheKey";
//
//   static final CustomCacheManager _instance = CustomCacheManager._();
//
//   factory CustomCacheManager() {
//     return _instance;
//   }
//
//   CustomCacheManager._()
//       : super(
//     Config(
//       key,
//       stalePeriod: const Duration(days: 100), // 캐시 유지 기간 설정
//       // 다른 설정 추가
//     ),
//   );
// }