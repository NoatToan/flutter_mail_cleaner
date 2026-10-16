import 'dart:async';

import 'package:ai_smart_mail/core/theme/app_tokens.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Makes the top [AppPane.toolbarHeight] band of the macOS window behave like
/// a native title bar (the real one is hidden under Flutter content):
/// double-click empty space → zoom/minimize per System Settings, drag → move.
/// Clicks on anything with a click/text cursor (buttons, fields) pass through.
class WindowTitleBar extends StatefulWidget {
  const WindowTitleBar({required this.child, super.key});

  final Widget child;

  static const _channel = MethodChannel('ai_smart_mail/window');

  @override
  State<WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<WindowTitleBar> {
  static const _dragSlop = 3.0;
  Duration? _lastUp;
  Offset? _lastUpPos;
  Offset? _downPos;
  bool _dragging = false;

  bool get _enabled => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// True when the pointer is over empty title-bar space (not a control).
  bool _isEmptyTitleArea(Offset globalPos, int viewId) {
    if (globalPos.dy > AppPane.toolbarHeight) return false;
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(result, globalPos, viewId);
    for (final entry in result.path) {
      final target = entry.target;
      if (target is RenderMouseRegion) {
        final cursor = target.cursor;
        if (cursor != MouseCursor.defer && cursor != SystemMouseCursors.basic) return false;
      }
      if (target is RenderEditable) return false;
    }
    return true;
  }

  void _onDown(PointerDownEvent e) {
    _dragging = false;
    final empty = e.buttons == kPrimaryButton && _isEmptyTitleArea(e.position, e.viewId);
    _downPos = empty ? e.position : null;
  }

  void _onMove(PointerMoveEvent e) {
    final start = _downPos;
    if (start == null || _dragging) return;
    if ((e.position - start).distance > _dragSlop) {
      _dragging = true;
      unawaited(WindowTitleBar._channel.invokeMethod<void>('startDrag'));
    }
  }

  void _onUp(PointerUpEvent e) {
    final start = _downPos;
    _downPos = null;
    if (start == null || _dragging) return;
    final last = _lastUp;
    final lastPos = _lastUpPos;
    if (last != null &&
        lastPos != null &&
        e.timeStamp - last < kDoubleTapTimeout &&
        (e.position - lastPos).distance < kDoubleTapSlop) {
      _lastUp = null;
      unawaited(WindowTitleBar._channel.invokeMethod<void>('titleBarDoubleClick'));
      return;
    }
    _lastUp = e.timeStamp;
    _lastUpPos = e.position;
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onDown,
      onPointerMove: _onMove,
      onPointerUp: _onUp,
      child: widget.child,
    );
  }
}
