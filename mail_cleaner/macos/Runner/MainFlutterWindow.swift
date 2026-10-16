import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Unified, transparent titlebar: Flutter draws under it and the sidebar
    // reserves the top 52pt for the traffic lights (design/screens-macos).
    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    self.isMovableByWindowBackground = false

    // TECH_SPEC §2a: min 900×600, default 1360×860, frame remembered.
    self.contentMinSize = NSSize(width: 900, height: 600)
    if !self.setFrameUsingName("AISmartMailMainWindow") {
      let screen = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
      let size = NSSize(width: min(1360, screen.width), height: min(860, screen.height))
      let origin = NSPoint(x: screen.midX - size.width / 2, y: screen.midY - size.height / 2)
      self.setFrame(NSRect(origin: origin, size: size), display: true)
    }
    self.setFrameAutosaveName("AISmartMailMainWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)
    registerWindowChannel(flutterViewController)

    super.awakeFromNib()
  }

  /// Flutter content covers the titlebar, so the toolbar band forwards
  /// double-click (zoom) and drag (move) here — VS Code-style title area.
  private func registerWindowChannel(_ controller: FlutterViewController) {
    let channel = FlutterMethodChannel(
      name: "ai_smart_mail/window", binaryMessenger: controller.engine.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return result(nil) }
      switch call.method {
      case "titleBarDoubleClick":
        // Honor System Settings › Desktop & Dock › "Double-click a window's title bar to".
        switch UserDefaults.standard.string(forKey: "AppleActionOnDoubleClick") {
        case "Minimize": self.miniaturize(nil)
        case "None": break
        default: self.zoom(nil)
        }
        result(nil)
      case "startDrag":
        if let event = NSApp.currentEvent { self.performDrag(with: event) }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
