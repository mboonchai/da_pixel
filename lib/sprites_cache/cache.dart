import 'package:da_pixel/pixel.dart';

import 'base.dart';
import 'memory_cache.dart';

SpriteCache getCache() {
  return SpriteMemoryCache();
}

Future<void> preCacheSprites(
    Map<String, Future<PixelLoadResult> Function()> loadSpriteMap) async {
  var cache = getCache();

  for (var key in loadSpriteMap.keys) {
    if (cache.has(key)) {
      //return if already cached..
      continue;
    }

    var fnLoadSprite = loadSpriteMap[key];

    var result = await fnLoadSprite!();
    if (result.success && result.data != null) {
      cache.set(key, result.data!);
    }
  }
}

Future<PixelLoadResult> loadAndCache(
    String key, Future<PixelLoadResult> Function() fnLoadSprite) async {
  var cache = getCache();

  if (cache.has(key)) {
    return PixelLoadResult()
      ..success = true
      ..data = cache.get(key);
  }

  var result = await fnLoadSprite();
  if (result.success && result.data != null) {
    cache.set(key, result.data!);

    return PixelLoadResult()
      ..success = true
      ..data = cache.get(key);
  }

  return PixelLoadResult()..success = false;
}
