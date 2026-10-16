import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

/// Each feature owns `assets/translations/<feature>/<lang>.json` (top-level key
/// = feature name), so features never edit a shared translation file. This
/// loader merges them. Add a new feature's folder here and in pubspec.yaml.
class FeatureAssetLoader extends AssetLoader {
  const FeatureAssetLoader();

  static const features = [
    'common',
    'shell',
    'onboarding',
    'inbox',
    'dashboard',
    'smart_scan',
    'senders',
    'tags',
    'catch_up',
    'ai_command',
    'settings',
  ];

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final merged = <String, dynamic>{};
    for (final feature in features) {
      final raw = await rootBundle.loadString(
        '$path/$feature/${locale.languageCode}.json',
      );
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) merged.addAll(decoded);
    }
    return merged;
  }
}
