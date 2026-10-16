import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences.g.dart';

/// Overridden in main() with the loaded instance.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in main()',
);

/// redux-persist-style persistence (ai/flutter/02): a Notifier rehydrates in
/// build() via [readPersisted] and calls [persistOnChange] once, so every
/// later state change is saved automatically — no manual save() calls.
mixin PersistedState<T> on AnyNotifier<T, T> {
  String get storageKey;
  Object? toJson(T state);
  T fromJson(Object? json);

  T readPersisted(T fallback) {
    final raw = ref.read(sharedPreferencesProvider).getString(storageKey);
    if (raw == null) return fallback;
    try {
      return fromJson(jsonDecode(raw));
    } on FormatException {
      return fallback;
    }
  }

  void persistOnChange() {
    listenSelf((_, next) {
      unawaited(
        ref
            .read(sharedPreferencesProvider)
            .setString(storageKey, jsonEncode(toJson(next))),
      );
    });
  }
}
