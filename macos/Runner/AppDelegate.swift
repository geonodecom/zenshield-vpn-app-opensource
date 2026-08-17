import Cocoa
import FlutterMacOS
import NetworkExtension

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationDidFinishLaunching(_ notification: Notification) {
        VPNManager.useSystemExtension = true
        let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
        let registry = controller as FlutterPluginRegistry
        let messenger = registry.registrar(forPlugin: MethodHandler.name).messenger
        let vpnStatusChannel = FlutterEventChannel(name: "\(Bundle.main.serviceIdentifier)/vpn_status", binaryMessenger: messenger)
        vpnStatusChannel.setStreamHandler(VpnStatusStreamHandler())
        NotificationCenter.default.addObserver(
            forName: .NEVPNStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] note in
            guard let conn = note.object as? NEVPNConnection else { return }
            let statusDesc = self?.vpnStatusString(conn.status) ?? "\(conn.status.rawValue)"
            NSLog("[Zenshield] VPN connection status changed: %@ (%d)", statusDesc, conn.status.rawValue)
            VpnStatusStreamHandler.sendStatus(conn.status)
        }
        MethodHandler.register(with: registry.registrar(forPlugin: MethodHandler.name))
        RegisterGeneratedPlugins(registry: registry)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return false
    }

    private func vpnStatusString(_ status: NEVPNStatus) -> String {
        switch status {
        case .invalid: return "invalid"
        case .disconnected: return "disconnected"
        case .connecting: return "connecting"
        case .connected: return "connected"
        case .reasserting: return "reasserting"
        case .disconnecting: return "disconnecting"
        @unknown default: return "unknown"
        }
    }
}
