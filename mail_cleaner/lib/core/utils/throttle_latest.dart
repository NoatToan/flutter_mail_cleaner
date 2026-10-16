import 'dart:async';

/// UI refresh cadence for DB-driven streams. During sync the DB changes every
/// batch; without this, counts re-render many times per second and flicker.
const uiRefreshInterval = Duration(milliseconds: 800);

extension ThrottleLatest<T> on Stream<T> {
  /// Emits the first event immediately (so a single user action still feels
  /// instant), then at most once per [interval] with the LATEST value — no
  /// event is lost, intermediate ones are coalesced.
  Stream<T> throttleLatest([Duration interval = uiRefreshInterval]) {
    late StreamController<T> controller;
    StreamSubscription<T>? sub;
    Timer? timer;
    T? pending;
    var hasPending = false;
    var sourceDone = false;

    void flush() {
      if (hasPending) {
        hasPending = false;
        controller.add(pending as T);
        timer = Timer(interval, flush);
      } else {
        timer = null;
        if (sourceDone) unawaited(controller.close());
      }
    }

    controller = StreamController<T>(
      onListen: () {
        sub = listen(
          (event) {
            if (timer == null) {
              controller.add(event);
              timer = Timer(interval, flush);
            } else {
              pending = event;
              hasPending = true;
            }
          },
          onError: controller.addError,
          onDone: () {
            sourceDone = true;
            if (timer == null) unawaited(controller.close());
          },
        );
      },
      onPause: () => sub?.pause(),
      onResume: () => sub?.resume(),
      onCancel: () async {
        timer?.cancel();
        await sub?.cancel();
      },
    );
    return controller.stream;
  }
}
