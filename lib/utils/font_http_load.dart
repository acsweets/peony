import 'dart:convert' as convert;
import 'dart:developer';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

final Set<String> _loadedFonts = {};

Future<void> loadHttpFont({
  required String fontFamily,
  required String urlString,
}) async {
  try {
    if (_loadedFonts.contains(fontFamily)) {
      return;
    } else {
      _loadedFonts.add(fontFamily);
    }

    Future<ByteData?>? byteData;

    final assetManifestJson = await _loadAssetManifestJson();
    final assetPath = _findFamilyWithVariantAssetPath(
      fontFamily,
      assetManifestJson,
    );
    if (assetPath != null) {
      byteData = rootBundle.load(assetPath);
    }
    if (await byteData != null) {
      return _loadFontByteData(fontFamily, byteData);
    }

    //目前只适用于web端 web使用Service Worker对接口自动缓存
    //TODO: 添加其他平台的缓存逻辑

    byteData = _httpFetchFont(urlString);
    if (await byteData != null) {
      return _loadFontByteData(fontFamily, byteData);
    }
  } catch (e) {
    _loadedFonts.remove(fontFamily);
    log(e.toString());
    rethrow;
  }
}

Future<void> _loadFontByteData(
  String fontFamily,
  Future<ByteData?>? byteData,
) async {
  if (byteData == null) return;
  final fontData = await byteData;
  if (fontData == null) return;

  final fontLoader = _FontLoader(fontFamily);
  fontLoader.addFont(Future.value(fontData));
  await fontLoader.load();
}

Future<ByteData> _httpFetchFont(String urlString) async {
  Response response;
  try {
    response = await Dio().get(
      urlString,
      options: Options(responseType: ResponseType.bytes),
    );
  } catch (e) {
    throw Exception('Failed to load font with url $urlString: $e');
  }
  if (response.statusCode == 200) {
    return ByteData.view((response.data as Uint8List).buffer);
  } else {
    throw Exception('Failed to load font with url: $urlString');
  }
}

class _FontLoader {
  _FontLoader(this.family)
      : _loaded = false,
        _fontFutures = <Future<Uint8List>>[];

  final String family;

  bool _loaded;
  final List<Future<Uint8List>> _fontFutures;

  void addFont(Future<ByteData> bytes) {
    if (_loaded) {
      throw StateError('FontLoader is already loaded');
    }

    _fontFutures.add(
      bytes.then(
        (ByteData data) => Uint8List.view(
          data.buffer,
          data.offsetInBytes,
          data.lengthInBytes,
        ),
      ),
    );
  }

  Future<void> load() async {
    if (_loaded) {
      throw StateError('FontLoader is already loaded');
    }
    _loaded = true;

    final Iterable<Future<void>> loadFutures = _fontFutures.map(
      (Future<Uint8List> f) => f.then<void>(
        (Uint8List list) => loadFont(list, family),
      ),
    );
    await Future.wait(loadFutures.toList());
  }

  Future<void> loadFont(Uint8List list, String family) {
    return loadFontFromList(list, fontFamily: family);
  }
}

Future<Map<String, List<String>>?> _loadAssetManifestJson() async {
  try {
    final jsonString = await rootBundle.loadString('AssetManifest.json');
    final parsedJson = convert.json.decode(jsonString) as Map<String, dynamic>;
    final parsedManifest = <String, List<String>>{
      for (final entry in parsedJson.entries)
        entry.key: (entry.value as List<dynamic>).cast<String>(),
    };
    return SynchronousFuture(parsedManifest);
  } catch (e) {
    rootBundle.evict('AssetManifest.json');
    rethrow;
  }
}

String? _findFamilyWithVariantAssetPath(
  String fontFamily,
  Map<String, List<String>>? manifestJson,
) {
  if (manifestJson == null) return null;

  for (final assetList in manifestJson.values) {
    for (final String asset in assetList) {
      for (final matchingSuffix in ['.ttf', '.otf'].where(asset.endsWith)) {
        final assetWithoutExtension =
            asset.substring(0, asset.length - matchingSuffix.length);
        //TODO: 只匹配了字体名，考虑添加fontWeiget
        if (assetWithoutExtension.endsWith(fontFamily)) {
          return asset;
        }
      }
    }
  }

  return null;
}
