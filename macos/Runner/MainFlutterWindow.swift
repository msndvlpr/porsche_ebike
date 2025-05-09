import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    //let windowFrame = self.frame
    self.contentViewController = flutterViewController
    let initialSize = NSSize(width: 800, height: 600)
        let screenFrame = NSScreen.main?.frame ?? NSRect.zero

        // Center the window
        let origin = NSPoint(
          x: (screenFrame.width - initialSize.width) / 2,
          y: (screenFrame.height - initialSize.height) / 2
        )

    self.setFrame(NSRect(origin: origin, size: initialSize), display: true)
    RegisterGeneratedPlugins(registry: flutterViewController)
    super.awakeFromNib()
  }
}
