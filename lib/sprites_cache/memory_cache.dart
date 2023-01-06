import 'package:da_pixel/pixels_loader/base.dart';

import 'base.dart';

class SpriteMemoryCache extends SpriteCache {
  Map cacheMap = <String, PixelData>{};

  @override
  PixelData? get(String key) {
    if (cacheMap.containsKey(key)) {
      return cacheMap[key];
    }

    return null;
  }

  @override
  set(String key, PixelData data) {
    cacheMap[key] = data;
  }

  @override
  bool has(String key) {
    return cacheMap.containsKey(key);
  }
  
  static final SpriteMemoryCache _instance = SpriteMemoryCache._spriteMemoryCache();
  factory SpriteMemoryCache() {
    return _instance;
  }
  SpriteMemoryCache._spriteMemoryCache();
  
}
